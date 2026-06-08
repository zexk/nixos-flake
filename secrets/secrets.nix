let
  # Personal SSH key — used for editing secrets locally with `agenix -e`
  user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPdJS+bfCCg2aYL3SzU573JjGBEUAwgF0Hp77Hrvdmat";

  # Host SSH key — used for decryption at boot via /etc/ssh/ssh_host_ed25519_key
  # Add this so the host can decrypt secrets without your personal key being present.
  # Run on kuwadorian: cat /etc/ssh/ssh_host_ed25519_key.pub
  # system = "ssh-ed25519 AAAA...";

  all = [
    user # system
  ];
in
{
  #  "secret1.age".publicKeys = all;
}
