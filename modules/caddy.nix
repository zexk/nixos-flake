{
  flake.nixosModules.caddy =
    { ... }:
    {
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
          credentialsFile = "/home/zexk/.cloudflared/3d321e13-9089-45b4-a862-e6b18b5d22b4.json";
          default = "http_status:404";
          ingress = {
            "zexk.xyz" = "http://localhost:80";
            "www.zexk.xyz" = "http://localhost:80";
          };
        };
      };

      networking.firewall.allowedTCPPorts = [
        80
        443
      ];
    };
}
