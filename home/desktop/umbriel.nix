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
        cursor = {
          theme = "catppuccin-mocha-dark-cursors";
          size = 24;
        };
        # English (US) layout with intl variant, as on the niri session.
        keyboard = {
          layout = "us";
          variant = "intl";
          options = "caps:escape";
          numlock_toggle = true;
        };
        focus = {
          follows_mouse = true;
        };
      };

      layout = {
        extent_presets = [
          0.333
          0.5
          0.667
          1.0
        ];
        scrolling = {
          default_extent_fraction = 1.0;
        };
      };

      keybinds = {
        "Mod+T" = {
          action = "spawn foot";
          repeat = false;
        };
        "Mod+B" = {
          action = "spawn firefox";
          repeat = false;
        };
        "Mod+N" = {
          action = "spawn sone";
          repeat = false;
        };
        "Mod+E" = {
          action = "spawn nautilus";
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

        # Noctalia
        "Mod+Space" = "spawn vicinae toggle";
        "Mod+V" = "spawn vicinae vicinae://launch/clipboard/history";
        "Mod+S" = "spawn noctalia msg panel-toggle control-center";
        "Mod+Comma" = "spawn noctalia msg settings-toggle";
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
        "Mod+J" = "window-focus-down";
        "Mod+K" = "window-focus-up";
        "Mod+L" = "window-focus-right";
        "Mod+F1" = "window-focus-next";
        "Mod+Shift+Left" = "column-move-left";
        "Mod+Shift+Down" = "window-move-down";
        "Mod+Shift+Up" = "window-move-up";
        "Mod+Shift+Right" = "column-move-right";

        # Workspaces
        "Mod+Page_Down" = "workspace-next";
        "Mod+Page_Up" = "workspace-previous";
        "Mod+U" = "workspace-next";
        "Mod+I" = "workspace-previous";
        "Mod+Ctrl+Page_Down" = "window-move-to-workspace-next";
        "Mod+Ctrl+Page_Up" = "window-move-to-workspace-previous";
        "Mod+Ctrl+U" = "window-move-to-workspace-next";
        "Mod+Ctrl+I" = "window-move-to-workspace-previous";
        "Mod+WheelDown" = "workspace-next";
        "Mod+WheelUp" = "workspace-previous";
        "Mod+Ctrl+WheelDown" = "window-move-to-workspace-next";
        "Mod+Ctrl+WheelUp" = "window-move-to-workspace-previous";
        "Mod+WheelRight" = "window-focus-right";
        "Mod+WheelLeft" = "window-focus-left";
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
        "Mod+G" = {
          action = "window-toggle-floating";
          repeat = false;
        };
        "Mod+Shift+G" = {
          action = "window-focus-switch-floating";
          repeat = false;
        };
        "Mod+P" = {
          action = "window-toggle-pinned";
          repeat = false;
        };
        "Mod+M" = {
          action = "window-toggle-maximize-to-edges";
          repeat = false;
        };
        "Mod+F" = {
          action = "window-toggle-fullscreen";
          repeat = false;
        };
        "Mod+Ctrl+F" = {
          action = "window-toggle-maximize";
          repeat = false;
        };
        "Mod+R" = "window-cycle-primary-extent";
        "Mod+Shift+R" = "window-cycle-primary-extent-back";
        "Mod+Minus" = "window-modify-width-left -0.1";
        "Mod+Equal" = "window-modify-width-right 0.1";
        "Mod+Shift+Minus" = "window-modify-height-down -0.1";
        "Mod+Shift+Equal" = "window-modify-height-up 0.1";

        # Scratchpad
        "Mod+Shift+Space" = {
          action = "window-move-to-scratchpad";
          repeat = false;
        };
        "Mod" = "scratchpad-toggle";
        "Mod+Ctrl+Space" = {
          action = "window-restore-from-scratchpad";
          repeat = false;
        };
        "Mod+Tab" = "scratchpad-focus-next";
      };
    };
  };

  programs.noctalia.settings.shell = {
    umbriel_overview_type_to_launch_enabled = true;
    umbriel_overview_close_on_launch_enabled = true;
  };

  services.polkit-gnome.enable = true;
}
