{
  services.mpd = {
    enable = true;
    extraConfig = ''
      			follow_outside_symlinks "yes"
      			follow_inside_symlinks "yes"
      		'';
    musicDirectory = "/home/zexk/music";
    network.listenAddress = "any";
    network.startWhenNeeded = true;
  };
}
