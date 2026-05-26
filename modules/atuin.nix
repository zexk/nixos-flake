_: {
  flake.homeModules.atuin = _: {
    programs.atuin = {
      enable = true;
      enableBashIntegration = true;
      settings = {
        auto_sync = false;
        update_check = false;
        search_mode = "fuzzy";
        filter_mode = "global";
        filter_mode_shell_up_key_binding = "session";
        show_preview = true;
        max_preview_height = 4;
        exit_mode = "return-original";
        history_filter = [
          "^pass "
          "^gpg "
        ];
      };
    };
  };
}
