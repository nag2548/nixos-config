{ inputs, config, ... }:
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
        default.path = ../themes/bg-new.jpg;
      };
      bar.default = {
        background_opacity = 0.5;
        capsule = true;
        capsule_padding = 4.0;
        capsule_radius = 8;
        margin_ends = 12;
        concave_edge_corners = false;
        start = [
          "workspaces"
          "media"
        ];
        center = [ "group:g1" ];
        end = [
          "tray"
          "notifications"
          "network"
          "bluetooth"
          "volume"
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
            widget_spacing = 12;
          }
        ];
      };
      location = {
        address = "Pfaffenhofen, DE";
      };
      control_center.calendar = {
        show_week_numbers = true;
      };
      widget = {
        media = {
          hide_when_no_media = true;
        };
        network = {
          show_label = false;
        };
        date.format = "{:%a %-d %b %Y}";
      };
      calendar = {
        enabled = true;
        account = {
          nextcloud_personal = {
            type = "caldav";
            name = "Personal";
            provider = "custom";
            server_url = "https://nextcloud.zimtix.de/remote.php/dav/";
            username = "nadine";
            calendars = [ ];
            credential_source = "file";
            password_file = config.sops.secrets.nextcloud-password.path;
          };
          holidays = {
            name = "German Holidays";
            server_url = "https://www.feiertage-deutschland.de/kalender-download/ics/feiertage-deutschland.ics";
            type = "ics";
            color = "#f38ba8";
          };
        };
        reminders = {
          enabled = true;
          use_event_reminders = true;
        };
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
      notification = {
        history_retention_hours = 8;
        filter_order = [
          "filter"
          "filter-2"
        ];
        filter = {
          "filter" = {
            allow_permanent = false;
            bypass_dnd = false;
            enabled = true;
            match = "signal";
            play_sound = false;
            save_history = true;
            show_toast = false;
          };
          "filter-2" = {
            allow_permanent = false;
            bypass_dnd = false;
            enabled = true;
            match = "telegram";
            play_sound = false;
            save_history = true;
            show_toast = false;
          };
        };
      };
    };
  };
}
