_: {
  flake.nixosModules.secrets =
    { ... }:
    {
      # agenix decrypts using /etc/ssh/ssh_host_ed25519_key at boot by default.
      # The host's public key must be listed in secrets/secrets.nix for each secret.

      #      age.secrets.secret1 = {
      #        file = ../secrets/secret1.age;
      #        mode = "0400";
      #        owner = "root";
      #      };

      # Pattern for adding new secrets:
      #
      # 1. Add to secrets/secrets.nix:
      #      "mySecret.age".publicKeys = all;
      #
      # 2. Encrypt:
      #      cd secrets && agenix -e mySecret.age
      #
      # 3. Declare here:
      #      age.secrets.mySecret = {
      #        file = ../secrets/mySecret.age;
      #        mode = "0400";      # or "0440" for group-readable
      #        owner = "myuser";   # service user that reads it
      #      };
      #
      # 4. Reference in any NixOS module:
      #      config.age.secrets.mySecret.path
      #      # resolves to /run/agenix/mySecret at runtime
    };
}
