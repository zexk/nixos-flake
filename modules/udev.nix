{ ... }:
{
  flake.nixosModules.udev = _: {
    services.udev.extraRules = ''
      	ACTION=="add|change", KERNEL=="event[0-9]*", ATTRS{name}=="Sony Interactive Entertainment Wireless Controller", ENV{LIBINPUT_IGNORE_DEVICE}="1"
      	ACTION=="add|change", KERNEL=="event[0-9]*", ATTRS{name}=="Sony Interactive Entertainment Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
      	ACTION=="add|change", KERNEL=="event[0-9]*", ATTRS{name}=="Sony Interactive Entertainment Wireless Controller Motion Sensors", ENV{LIBINPUT_IGNORE_DEVICE}="1"
      	ACTION=="add|change", KERNEL=="event[0-9]*", ATTRS{name}=="Sony Interactive Entertainment Wireless Controller Headset Jack", ENV{LIBINPUT_IGNORE_DEVICE}="1"
    '';
  };
}
