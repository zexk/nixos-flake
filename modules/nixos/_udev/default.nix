{
  services.udev = {
    enable = true;
    extraRules = ''
      			SUBSYSTEM=="usb", ATTR{idVendor}=="17ef", ATTR{idProduct}=="7e7d", MODE="0666", GROUP="plugdev"
      		'';
  };
}
