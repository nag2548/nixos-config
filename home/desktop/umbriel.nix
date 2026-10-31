{ inputs, ... }:
{
  imports = [
    ./noctalia.nix
    ./screenshot.nix
    inputs.umbriel.homeModules.default
  ];

  programs.umbriel = {
    enable = true;

    settings = {
      general = {
        autostart = [ "noctalia" ];
        mod_key = "Super";
      };

      input = {
        middle_click_paste = false;
        cursor = {
          theme = "catppuccin-mocha-dark-cursors";
          size = 24;
          follows_focus = true;
          hide_when_typing = true;
        };
        keyboard = {
          layout = "us";
          variant = "intl";
          options = "caps:escape";
          numlock_toggle = true;
        };
      };

      layout = {
        extent_presets = [
          0.333
          0.5
          0.667
          1.0
        ];
        gap = 4;
        struts = {
          left = 12;
          right = 12;
          top = 0;
          bottom = 0;
        };
        scrolling = {
          default_extent_fraction = 1.0;
        };
      };

      # Catppuccin Mocha palette.
      colors = {
        background = "#1e1e2e";
        text_primary = "#cdd6f4";
        text_muted = "#a6adc8";
        accent_primary = "#cba6f7";
        accent_secondary = "#89b4fa";
        warning = "#f9e2af";
        error = "#f38ba8";
        insert_hint = "#89b4fa80";
        backdrop = "#11111b";
        shadow = "#00000080";

        border = {
          focused = "#cba6f7";
          unfocused = "#45475a";
          outer = "#181825";
        };

        overview = {
          background_tint = "#11111b30";
          workspace_background = "#11111b44";
          badge = "#cba6f7";
        };

        tab_bar = {
          background = "#181825";
          text = "#a6adc8";
          active = "#cba6f7";
          active_text = "#1e1e2e";
          active_unfocused = "#45475a";
          active_unfocused_text = "#cdd6f4";
          urgent = "#f38ba8";
          urgent_text = "#1e1e2e";
        };

        title_bar = {
          background = "#313244";
          background_unfocused = "#181825";
          text = "#cdd6f4";
          text_unfocused = "#a6adc8";
          close = "#f38ba8";
          close_glyph = "#1e1e2e";
          close_glyph_hover = "#1e1e2e";
          maximize = "#89b4fa";
          maximize_glyph = "#1e1e2e";
          maximize_glyph_hover = "#1e1e2e";
          minimize = "#f9e2af";
          minimize_glyph = "#1e1e2e";
          minimize_glyph_hover = "#1e1e2e";
        };
      };

      appearance = {
        border_width = 3;
        blur = {
          enabled = true;
          optimized = true;
          passes = 2;
          radius = 5;
          noise = 0.02;
          brightness = 0.9;
          contrast = 0.9;
          saturation = 1.1;
        };
        shadow = {
          enabled = true;
          softness = 10;
          offset_x = 2;
          offset_y = 2;
        };
      };

      output = {
        "DP-2" = {
          mode = "2560x1440@165.080";
          focus_at_startup = true;
        };
        "HDMI-A-1" = {
          mode = "1920x1080@60.000";
          position = [
            0
            0
          ];
        };
      };

      keybinds = {
        "Mod+B" = {
          action = "spawn vicinae vicinae://launch/applications/firefox";
          repeat = false;
        };
        "Mod+E" = {
          action = "spawn vicinae vicinae://launch/applications/org.gnome.Nautilus";
          repeat = false;
        };
        "Mod+Semicolon" = {
          action = "spawn vicinae vicinae://launch/applications/com.onepassword.OnePassword";
          repeat = false;
        };
        "Mod+Shift+Space" = {
          action = "spawn 1password --quick-access";
          repeat = false;
        };

        "Mod+Q" = {
          action = "window-close";
          repeat = false;
        };
        "Super+Alt+L" = "spawn noctalia msg session lock";
        "Mod+Slash" = {
          action = "cheatsheet-toggle";
          repeat = false;
        };

        "Mod+Escape" = "session-quit";
        "Mod+Shift+Escape" = {
          action = "shortcuts-inhibit-toggle";
          allow_when_inhibited = true;
          repeat = false;
        };
        "Mod+O" = {
          action = "overview-toggle";
          repeat = false;
        };

        "Mod+Space" = "spawn vicinae toggle";
        "Mod+V" = "spawn vicinae vicinae://launch/clipboard/history";
        "Alt+Tab" = "spawn noctalia msg window-switcher";

        # Screenshots
        "Print" = "spawn noctalia msg screenshot-fullscreen";
        "Mod+Print" = "spawn noctalia msg screenshot-region";
        "Mod+Shift+Print" = "spawn noctalia msg screenshot-annotate";

        # Media, volume and brightness keys, routed through Noctalia
        "XF86AudioRaiseVolume" = {
          action = "spawn noctalia msg volume-up";
          allow_when_locked = true;
        };
        "XF86AudioLowerVolume" = {
          action = "spawn noctalia msg volume-down";
          allow_when_locked = true;
        };
        "XF86AudioMute" = {
          action = "spawn noctalia msg volume-mute";
          allow_when_locked = true;
          repeat = false;
        };
        "XF86AudioPlay" = {
          action = "spawn noctalia msg media toggle";
          allow_when_locked = true;
          repeat = false;
        };
        "XF86AudioNext" = {
          action = "spawn noctalia msg media next";
          allow_when_locked = true;
        };
        "XF86AudioPrev" = {
          action = "spawn noctalia msg media previous";
          allow_when_locked = true;
        };
        "XF86MonBrightnessUp" = {
          action = "spawn noctalia msg brightness-up";
          allow_when_locked = true;
        };
        "XF86MonBrightnessDown" = {
          action = "spawn noctalia msg brightness-down";
          allow_when_locked = true;
        };

        # Focus and movement
        "Mod+Left" = "window-focus-left";
        "Mod+Down" = "window-focus-down";
        "Mod+Up" = "window-focus-up";
        "Mod+Right" = "window-focus-right";
        "Mod+H" = "window-focus-left";
        "Mod+J" = "window-focus-or-workspace-down";
        "Mod+K" = "window-focus-or-workspace-up";
        "Mod+L" = "window-focus-right";
        "Mod+Ctrl+Left" = "column-move-left";
        "Mod+Ctrl+Down" = "window-move-down";
        "Mod+Ctrl+Up" = "window-move-up";
        "Mod+Ctrl+Right" = "column-move-right";
        "Mod+Ctrl+H" = "column-move-left";
        "Mod+Ctrl+J" = "window-move-or-workspace-down";
        "Mod+Ctrl+K" = "window-move-or-workspace-up";
        "Mod+Ctrl+L" = "column-move-right";

        # Monitor focus
        "Mod+Shift+Left" = "output-focus-left";
        "Mod+Shift+Down" = "output-focus-down";
        "Mod+Shift+Up" = "output-focus-up";
        "Mod+Shift+Right" = "output-focus-right";
        "Mod+Shift+H" = "output-focus-left";
        "Mod+Shift+J" = "output-focus-down";
        "Mod+Shift+K" = "output-focus-up";
        "Mod+Shift+L" = "output-focus-right";

        # Move the focused column to another monitor
        "Mod+Shift+Ctrl+Left" = "column-move-to-output-left";
        "Mod+Shift+Ctrl+Down" = "column-move-to-output-down";
        "Mod+Shift+Ctrl+Up" = "column-move-to-output-up";
        "Mod+Shift+Ctrl+Right" = "column-move-to-output-right";
        "Mod+Shift+Ctrl+H" = "column-move-to-output-left";
        "Mod+Shift+Ctrl+J" = "column-move-to-output-down";
        "Mod+Shift+Ctrl+K" = "column-move-to-output-up";
        "Mod+Shift+Ctrl+L" = "column-move-to-output-right";

        # Swap the focused window with its neighbour: A - B becomes B - A
        "Mod+Alt+Left" = "window-swap-left";
        "Mod+Alt+Down" = "window-swap-down";
        "Mod+Alt+Up" = "window-swap-up";
        "Mod+Alt+Right" = "window-swap-right";

        # Workspaces
        "Mod+WheelDown" = "workspace-next";
        "Mod+WheelUp" = "workspace-previous";
        "Mod+Ctrl+WheelDown" = "window-move-to-workspace-next";
        "Mod+Ctrl+WheelUp" = "window-move-to-workspace-previous";
        "Mod+WheelRight" = "window-focus-right";
        "Mod+WheelLeft" = "window-focus-left";
        "Mod+1" = "workspace-switch 1";
        "Mod+2" = "workspace-switch 2";
        "Mod+3" = "workspace-switch 3";
        "Mod+4" = "workspace-switch 4";
        "Mod+5" = "workspace-switch 5";
        "Mod+6" = "workspace-switch 6";
        "Mod+7" = "workspace-switch 7";
        "Mod+8" = "workspace-switch 8";
        "Mod+9" = "workspace-switch 9";
        "Mod+Ctrl+1" = "window-move-to-workspace 1";
        "Mod+Ctrl+2" = "window-move-to-workspace 2";
        "Mod+Ctrl+3" = "window-move-to-workspace 3";
        "Mod+Ctrl+4" = "window-move-to-workspace 4";
        "Mod+Ctrl+5" = "window-move-to-workspace 5";
        "Mod+Ctrl+6" = "window-move-to-workspace 6";
        "Mod+Ctrl+7" = "window-move-to-workspace 7";
        "Mod+Ctrl+8" = "window-move-to-workspace 8";
        "Mod+Ctrl+9" = "window-move-to-workspace 9";

        # Window state and layout
        "Mod+BracketLeft" = "window-consume-or-expel-left";
        "Mod+BracketRight" = "window-consume-or-expel-right";
        "Mod+P" = {
          action = "window-toggle-pinned";
          repeat = false;
        };
        "Mod+M" = {
          action = "window-toggle-maximize-to-edges";
          repeat = false;
        };
        "Mod+F" = {
          action = "window-toggle-maximize";
          repeat = false;
        };
        "Mod+Shift+F" = {
          action = "window-toggle-fullscreen";
          repeat = false;
        };
        "Mod+R" = "window-cycle-primary-extent";
        "Mod+Shift+R" = "window-cycle-primary-extent-back";
        "Mod+Minus" = "window-modify-width-left -0.1";
        "Mod+Equal" = "window-modify-width-right 0.1";
        "Mod+Shift+Minus" = "window-modify-height-down -0.1";
        "Mod+Shift+Equal" = "window-modify-height-down 0.1";

        # Scratchpads
        "Mod+Alt+T" = {
          action = "scratchpad-toggle terminal";
          repeat = false;
        };
        "Mod+Alt+M" = {
          action = "scratchpad-toggle music";
          repeat = false;
        };
        "Mod+Alt+Comma" = {
          action = "scratchpad-toggle messengers";
          repeat = false;
        };
        "Mod+Tab" = {
          action = "scratchpad-focus-next messengers";
          repeat = false;
        };
      };

      # Named scratchpads. Defining any of these removes the implicit
      # "default" scratchpad, so every scratchpad action needs a name.
      scratchpad = [
        {
          name = "terminal";
          spawn_when_empty = "foot --app-id scratchpad-terminal";
          proportional_size = true;
        }
        {
          name = "music";
          spawn_when_empty = "sone";
          proportional_size = true;
        }
        {
          name = "messengers";
          proportional_size = true;
        }
      ];

      # Applications that open straight into their scratchpad, hidden until
      # the pad is toggled.
      window_rule = [
        {
          match.app_id = "^scratchpad-terminal$";
          default_scratchpad = "terminal";
          default_floating_size.width = 0.88;
          default_floating_size.height = 0.88;
        }
        {
          match.app_id = "signal";
          default_scratchpad = "messengers";
          default_floating_size.width = 0.5;
          default_floating_size.height = 0.6;
          block_capture = true;
        }
        {
          match.app_id = "telegram";
          default_scratchpad = "messengers";
          default_floating_size.width = 0.5;
          default_floating_size.height = 0.6;
          block_capture = true;
        }
        {
          match.app_id = "sone";
          default_scratchpad = "music";
          default_floating_size.width = 0.8;
          default_floating_size.height = 0.8;
        }
        {
          match.app_id = "^com[.]onepassword[.]OnePassword$";
          default_floating = true;
          default_floating_size.width = 0.5;
          default_floating_size.height = 0.6;
          block_capture = true;
        }
        {
          match.app_id = "^org[.]gnome[.]Nautilus$";
          default_floating = true;
          default_floating_size.width = 0.5;
          default_floating_size.height = 0.6;
        }
      ];
    };
  };

  programs.noctalia.settings.shell = {
    umbriel_overview_type_to_launch_enabled = true;
    umbriel_overview_close_on_launch_enabled = true;
  };

  services.polkit-gnome.enable = true;
}
