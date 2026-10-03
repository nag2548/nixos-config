{ inputs, ... }:
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

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
        window_switcher = {
          style = "compact";
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
        margin_ends = 12;
        start = [ "workspaces" ];
        center = [ "group:g1" ];
        end = [
          "media"
          "tray"
          "notifications"
          "network"
          "bluetooth"
          "volume"
          "brightness"
          "battery"
          "session"
        ];
        capsule_group = [
          {
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
          }
        ];
      };
      location = {
        address = "Pfaffenhofen, DE";
      };
      control_center.calendar = {
        show_week_numbers = true;
      };
      idle = {
        behavior_order = [
          "lock"
          "screen-off"
          "lock-and-suspend"
        ];
        behavior = {
          lock = {
            action = "lock";
            enabled = true;
            timeout = 600.0;
          };
          lock-and-suspend = {
            action = "lock_and_suspend";
            enabled = true;
            timeout = 900.0;
          };
          screen-off = {
            action = "screen_off";
            enabled = true;
            timeout = 660.0;
          };
        };
      };
    };
  };
}
