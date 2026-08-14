{
  programs.noctalia = {
    enable = true;
    settings = {
      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Catppuccin";
      };
      shell = {
        niri_overview_type_to_launch_enabled = true;
        panel = {
          open_near_click_control_center = true;
        };
      };
      wallpaper = {
        enabled = true;
        fill_mode = "crop";
        default.path = ../themes/bg-minimal.jpg;
      };
      bar.default = {
        capsule = true;
        capsule_padding = 4.0;
        start = [
          "launcher"
          "workspaces"
        ];
      };
      location = {
        address = "Pfaffenhofen, DE";
      };
    };
  };
}
