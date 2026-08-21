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
        margin_ends = 8;
        start = [ "workspaces" ];
        center = [ "group:g1" ];
        capsule_group = {
          id = "g1";
          accordion = false;
          accordion_direction = "end";
          enabled = true;
          fill = "surface_variant";
          members = [
            "date"
            "clock"
          ];
          opacity = 0.0;
          padding = 4.0;
        };
      };
      location = {
        address = "Pfaffenhofen, DE";
      };
      control_center.calendar = {
        show_week_numbers = true;
      };
    };
  };
}
