let
  # Personal SSH key — used for editing secrets locally with `agenix -e`
  user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPdJS+bfCCg2aYL3SzU573JjGBEUAwgF0Hp77Hrvdmat";

  # Host SSH key — used for decryption at boot via /etc/ssh/ssh_host_ed25519_key
  system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICVDRJuBzOE7EEawLtlZ8oacO3AJcZQ12wzNPfIVHtXv";

  all = [
    user
    system
  ];
in
{
  "cloudflared.age".publicKeys = all;
  "github.age".publicKeys = all;
}
