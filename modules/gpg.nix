_: {
  flake.homeModules.gpg =
    { pkgs, ... }:
    {
      programs.gpg = {
        enable = true;
        package = pkgs.gnupg;
        settings = {
          use-agent = true;
          keyserver = "hkps://keys.openpgp.org";
          keyserver-options = "auto-key-retrieve no-honor-keyserver-url";
          personal-cipher-preferences = "AES256 AES192 AES";
          personal-digest-preferences = "SHA512 SHA384 SHA256";
          cert-digest-algo = "SHA512";
          default-preference-list = "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";
          no-comments = true;
          no-emit-version = true;
          with-fingerprint = true;
        };
        mutableKeys = true;
        mutableTrust = true;
      };
    };
}
