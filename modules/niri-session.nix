{ pkgs, ... }:
{
  programs = {
    niri.enable = true;
  };

  services.displayManager.noctalia-greeter = {
    enable = true;
    settings = {
      cursor = {
        path = "${pkgs.catppuccin-cursors.mochaDark}/share/icons";
        theme = "catppuccin-mocha-dark-cursors";
        size = 24;
      };
      appearance = {
        scheme = "Synced";
        theme_mode = "dark";
        hide_logo = true;
        palette = {
          primary = "#cba6f7";
          on_primary = "#1e1e2e";
          secondary = "#89b4fa";
          on_secondary = "#1e1e2e";
          tertiary = "#94e2d5";
          on_tertiary = "#1e1e2e";
          error = "#f38ba8";
          on_error = "#1e1e2e";
          surface = "#1e1e2e";
          on_surface = "#cdd6f4";
          surface_variant = "#313244";
          on_surface_variant = "#bac2de";
          outline = "#45475a";
          shadow = "#11111b";
          hover = "#94e2d5";
          on_hover = "#1e1e2e";
        };
        wallpaper = {
          path = ../home/themes/bg-minimal.jpg;
          fill_mode = "crop";
        };
      };
    };
  };
}
