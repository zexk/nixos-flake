_:
{
  flake.homeModules.dunst =
    _:
    {
      services.dunst = {
        enable = true;
        settings = {
          global = {
            width = 300;
            height = 150;
            enable_posix_regex = true;
            notification_limit = 3;
            follow = "mouse";
            offset = "10x30";
            origin = "top-right";
            frame_width = 3;
            gap_size = 3;
          };
        };
      };
    };
}
