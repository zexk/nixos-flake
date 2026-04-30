{
  services.udev.extraRules = ''
    ATTRS{name}=="Sony Interactive Entertainment DualSense Wireless Controller Touchpad",
    ENV{LIBINPUT_IGNORE_DEVICE}="1"
  '';
}
