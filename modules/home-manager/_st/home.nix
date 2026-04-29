{ pkgs, ... }:
{
  home.packages = [
    pkgs.st.overrideAttrs
    ({
      src = ./st;
    })
  ];
}
