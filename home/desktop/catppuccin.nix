{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.catppuccin.homeModules.catppuccin
  ];
  home.pointerCursor.enable = true;

  catppuccin = {
    enable = true;
    autoEnable = true;
    gtk = {
      icon.enable = true;
    };
    cursors = {
      enable = true;
      accent = "dark";
    };

    tmux = {
      extraConfig = ''
        set -g @catppuccin_window_status_style "rounded"

        # Load catppuccin first so @catppuccin_status_* options are defined
        # when status-right is set with -F. The home-manager module's plugin
        # entry sources catppuccin after this extraConfig, which is too late.
        run-shell ${
          inputs.catppuccin.packages.${pkgs.stdenv.hostPlatform.system}.sources.tmux
        }/catppuccin.tmux

        # Make the status line pretty and add some modules
        set -g status-right-length 100
        set -g status-left-length 100
        set -g status-left ""
        set -g status-right "#{E:@catppuccin_status_application}"
        set -agF status-right "#{E:@catppuccin_status_cpu}"
        set -agF status-right "#{E:@catppuccin_status_ram}"
        set -ag status-right "#{E:@catppuccin_status_session}"
        # set -ag status-right "#{E:@catppuccin_status_uptime}"
        # set -agF status-right "#{E:@catppuccin_status_battery}"
      '';
    };

    thunderbird = {
      profile = "default";
    };
  };

  # home.pointerCursor = {
  #   enable = true;
  #   package = pkgs.catppuccin-cursors.mochaDark;
  #   name = "catppuccin-mocha-dark-cursors";
  #   size = 24;
  #   gtk.enable = true;
  #   x11.enable = true;
  # };
}
