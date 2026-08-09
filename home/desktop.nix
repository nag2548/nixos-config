{ pkgs, ... }:

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
        dock = {
          enabled = true;
          active_monitor_only = true;
        };
        shell = {
          niri_overview_type_to_launch_enabled = true;
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
  };

  services = {
    polkit-gnome.enable = true;
  };

  home.packages = with pkgs; [
    swaybg
    xwayland-satellite
    nautilus
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

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
    xdgOpenUsePortal = true;
    config.common.default = "*";
  };

  home.sessionVariables = {
    GDK_BACKEND = "wayland,x11";
  };
}
