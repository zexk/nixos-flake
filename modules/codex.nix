{ inputs, ... }:
{
  flake.homeModules.codex =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.programs.codex;

      codex = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.codex;
      tomlFormat = pkgs.formats.toml { };

      # Keep this path calculation identical to Home Manager's Codex module so
      # we can disable its store-backed config.toml entry reliably.
      useXdgDirectories = config.home.preferXdgDirectories;
      xdgConfigHome = lib.removePrefix config.home.homeDirectory config.xdg.configHome;
      configDir = if useXdgDirectories then "${xdgConfigHome}/codex" else ".codex";
      codexHome =
        if useXdgDirectories then
          "${config.xdg.configHome}/codex"
        else
          "${config.home.homeDirectory}/.codex";
      liveConfig = "${codexHome}/config.toml";
      managedStateDir = "${config.xdg.stateHome}/home-manager/codex";
      previousManagedConfig = "${managedStateDir}/managed-config.toml";

      # Mirror Home Manager's generated config so MCP servers, plugins, and
      # marketplaces remain declarative even though config.toml is writable.
      atLeast = version: cfg.package == null || lib.versionAtLeast (lib.getVersion cfg.package) version;
      migrateLegacyProfiles = atLeast "0.134.0";
      rawSettings = if cfg.settings == null then { } else cfg.settings;

      hasLegacyProfileSettings =
        migrateLegacyProfiles && ((rawSettings ? profile) || (rawSettings ? profiles));
      baseSettings =
        if hasLegacyProfileSettings then
          lib.removeAttrs rawSettings [
            "profile"
            "profiles"
          ]
        else
          rawSettings;

      transformedMcpServers = lib.optionalAttrs (cfg.enableMcpIntegration && config.programs.mcp.enable) (
        lib.mapAttrs (
          name: server:
          lib.hm.mcp.transformMcpServer {
            inherit server;
            exclude = [
              "headers"
              "type"
            ];
            extraTransforms = [
              (s: s // lib.optionalAttrs (s.headers or { } != { }) { http_headers = s.headers; })
              lib.hm.mcp.addType
              (lib.hm.mcp.wrapEnvFilesCommand { inherit pkgs name; })
            ];
          }
        ) config.programs.mcp.servers
      );

      mkPluginName =
        plugin:
        let
          manifestPath = plugin + "/.codex-plugin/plugin.json";
          manifestName =
            if !lib.isDerivation plugin && builtins.pathExists manifestPath then
              (builtins.fromJSON (builtins.readFile manifestPath)).name
            else
              null;
          fallbackName =
            if lib.isDerivation plugin then
              plugin.pname or (lib.getName plugin)
            else
              baseNameOf (toString plugin);
        in
        builtins.unsafeDiscardStringContext (if manifestName != null then manifestName else fallbackName);

      generatedPluginSettings =
        lib.optionalAttrs (cfg.plugins != [ ] || cfg.marketplaces != { }) {
          features.plugins = true;
        }
        // lib.optionalAttrs (cfg.plugins != [ ]) {
          plugins = lib.listToAttrs (
            map (
              plugin:
              lib.nameValuePair "${mkPluginName plugin}@home-manager" {
                enabled = true;
              }
            ) cfg.plugins
          );
        }
        // lib.optionalAttrs (cfg.marketplaces != { }) {
          marketplaces = lib.mapAttrs (_name: source: {
            source_type = "local";
            source = "${source}";
          }) cfg.marketplaces;
        };

      mergedSettingsWithoutMcp = lib.recursiveUpdate baseSettings generatedPluginSettings;
      settingsMcpServers = lib.attrByPath [ "mcp_servers" ] { } mergedSettingsWithoutMcp;
      mergedMcpServers = transformedMcpServers // settingsMcpServers;
      managedSettings =
        mergedSettingsWithoutMcp
        // lib.optionalAttrs (mergedMcpServers != { }) {
          mcp_servers = mergedMcpServers;
        };

      generatedManagedConfig = tomlFormat.generate "codex-home-manager-config" managedSettings;

      python = pkgs.python3.withPackages (pythonPackages: [ pythonPackages.tomlkit ]);
      mergeScript = pkgs.writeText "merge-codex-config.py" ''
        import copy
        import os
        import sys
        import tempfile
        from collections.abc import MutableMapping
        from pathlib import Path

        import tomlkit


        def load_toml(path: Path, *, missing_ok: bool):
            try:
                text = path.read_text(encoding="utf-8")
            except FileNotFoundError:
                if missing_ok:
                    return tomlkit.document()
                raise

            if text.strip() == "":
                return tomlkit.document()

            try:
                return tomlkit.parse(text)
            except Exception as error:
                raise RuntimeError(f"failed to parse TOML at {path}: {error}") from error


        def is_table(value):
            return isinstance(value, MutableMapping)


        def prune_removed_managed_keys(live, previous, current):
            for key, previous_value in list(previous.items()):
                if key not in current:
                    live.pop(key, None)
                    continue

                if (
                    key in live
                    and is_table(previous_value)
                    and is_table(current[key])
                    and is_table(live[key])
                ):
                    prune_removed_managed_keys(live[key], previous_value, current[key])


        def merge_static_over_live(live, static_config):
            for key, static_value in static_config.items():
                if key in live and is_table(live[key]) and is_table(static_value):
                    merge_static_over_live(live[key], static_value)
                else:
                    live[key] = copy.deepcopy(static_value)


        def atomic_write(path: Path, text: str, mode: int = 0o600):
            path.parent.mkdir(parents=True, exist_ok=True)

            file_descriptor, temporary_name = tempfile.mkstemp(
                prefix=f".{path.name}.",
                dir=path.parent,
                text=True,
            )
            temporary_path = Path(temporary_name)

            try:
                with os.fdopen(file_descriptor, "w", encoding="utf-8") as temporary_file:
                    temporary_file.write(text)
                    temporary_file.flush()
                    os.fsync(temporary_file.fileno())
                os.chmod(temporary_path, mode)
                os.replace(temporary_path, path)
            finally:
                temporary_path.unlink(missing_ok=True)


        def main():
            if len(sys.argv) != 4:
                raise SystemExit(
                    "usage: merge-codex-config.py LIVE_CONFIG PREVIOUS_MANAGED NEW_MANAGED"
                )

            live_path = Path(sys.argv[1])
            previous_path = Path(sys.argv[2])
            new_managed_path = Path(sys.argv[3])

            live_was_store_symlink = (
                live_path.is_symlink()
                and os.path.realpath(live_path).startswith("/nix/store/")
            )

            live = load_toml(live_path, missing_ok=True)
            if previous_path.exists():
                previous = load_toml(previous_path, missing_ok=False)
            elif live_was_store_symlink:
                # On the first migration, the old store target is the previous
                # declarative state. This lets us remove settings deleted in the
                # same Home Manager switch that enables mutable configuration.
                previous = copy.deepcopy(live)
            else:
                previous = tomlkit.document()
            current = load_toml(new_managed_path, missing_ok=False)

            # Remove settings that were previously Nix-owned but have now been
            # deleted from the declaration, then overlay the current declaration.
            prune_removed_managed_keys(live, previous, current)
            merge_static_over_live(live, current)

            atomic_write(live_path, tomlkit.dumps(live))
            atomic_write(previous_path, tomlkit.dumps(current))


        if __name__ == "__main__":
            main()
      '';
    in
    {
      programs.codex = {
        enable = true;
        package = codex;
        enableMcpIntegration = true;
      };

      # The upstream Home Manager module still computes and manages every other
      # Codex artifact, but it must not create config.toml as a /nix/store link.
      home.file."${configDir}/config.toml".enable = lib.mkForce false;

      home.activation.mergeMutableCodexConfig = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
        $DRY_RUN_CMD ${lib.getExe python} \
          ${lib.escapeShellArg mergeScript} \
          ${lib.escapeShellArg liveConfig} \
          ${lib.escapeShellArg previousManagedConfig} \
          ${lib.escapeShellArg generatedManagedConfig}
      '';
    };
}
