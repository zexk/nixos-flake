{ ... }:
{
  flake.nixosModules.udev = _: {
    services.udev.extraRules = ''
      	ACTION=="add|change", KERNEL=="event[0-9]*", ATTRS{product}=="DualSense Wireless Controller", ENV{LIBINPUT_IGNORE_DEVICE}="1"
    '';
  };
}
