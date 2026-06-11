{
  flake.nixosModules.caddy =
    { config, ... }:
    {
      # cloudflared runs with DynamicUser; the credentials file is handed
      # over via systemd LoadCredential, so root-owned 0400 is correct
      age.secrets.cloudflared = {
        file = ../secrets/cloudflared.age;
        mode = "0400";
      };

      services.caddy = {
        enable = true;
        virtualHosts.":80" = {
          extraConfig = ''
            root * /srv/http
            encode zstd gzip
            file_server
          '';
        };
      };

      services.cloudflared = {
        enable = true;
        tunnels."3d321e13-9089-45b4-a862-e6b18b5d22b4" = {
          credentialsFile = config.age.secrets.cloudflared.path;
          default = "http_status:404";
          ingress = {
            "zexk.xyz" = "http://localhost:80";
            "www.zexk.xyz" = "http://localhost:80";
          };
        };
      };
    };
}
