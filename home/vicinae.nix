{ ... }:
{
  programs.vicinae = {
    enable = true;
    systemd = {
      enable = true;
      autoStart = true;
      environment.USE_LAYER_SHELL = 1;
    };
    settings = {
      favicon_service = "twenty";
      pop_to_root_on_close = false;
      launcher_window.opacity = 0.90;
      applications = {
        entrypoints = {
          kitty = {
            alias = "t";
          };
          sone = {
            alias = "m";
          };
          firefox = {
            alias = "b";
          };
        };
      };
    };
  };
}
