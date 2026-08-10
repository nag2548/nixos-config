{ config, pkgs, ... }:

{
  programs = {
    noctalia = {
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
          default.path = ./themes/bg.png;
        };
        bar.default = {
          capsule = true;
          capsule_padding = 4.0;
          start = [
            "launcher"
            "workspaces"
          ];
        };
      };
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "catppuccin-mocha-mauve-standard";
      package = pkgs.catppuccin-gtk.override {
        variant = "mocha";
        accents = [ "mauve" ];
      };
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "catppuccin-mocha-dark";
      package = pkgs.catppuccin-cursors.mochaDark;
    };
    font = {
      name = "Inter";
      size = 10;
    };
    gtk3 = {
      bookmarks = [
        "file://${config.xdg.userDirs.download}"
        "file://${config.xdg.userDirs.documents}"
        "file:///mnt/documents/consume"
      ];
    };
  };

  services = {
    polkit-gnome.enable = true;
  };

  home.packages = with pkgs; [
    swaybg
    xwayland-satellite
    nautilus
    xdg-user-dirs-gtk
  ];

  xdg.configFile."niri/config.kdl".source =
    pkgs.runCommand "niri-config-checked"
      {
        nativeBuildInputs = [ pkgs.niri ];
      }
      ''
        niri validate --config ${./config/niri.kdl}
        cp ${./config/niri.kdl} $out
      '';

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-gnome
      ];
      xdgOpenUsePortal = true;
      config = {
        common.default = "*";
        niri = {
          "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
        };
      };
    };
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = [ "firefox.desktop" ];
        "application/xhtml+xml" = [ "firefox.desktop" ];
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
        "x-scheme-handler/mailto" = [ "thunderbird.desktop" ];
        "x-scheme-handler/net.thunderbird" = [ "thunderbird.desktop" ];
        "image/png" = [ "org.gnome.Loupe.desktop" ];
        "image/jpeg" = [ "org.gnome.Loupe.desktop" ];
        "image/gif" = [ "org.gnome.Loupe.desktop" ];
        "image/webp" = [ "org.gnome.Loupe.desktop" ];
        "image/svg+xml" = [ "org.gnome.Loupe.desktop" ];
      };
    };
  };

  home.sessionVariables = {
    GDK_BACKEND = "wayland,x11";
  };
}
