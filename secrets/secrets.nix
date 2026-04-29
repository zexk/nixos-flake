let
  user1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPdJS+bfCCg2aYL3SzU573JjGBEUAwgF0Hp77Hrvdmat";
in
{
  "secret1.age".publicKeys = [ user1 ];
}
