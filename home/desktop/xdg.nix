{ pkgs, ... }:
{
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
        "application/pdf" = "firefox.desktop";
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
        "x-scheme-handler/mailto" = [ "thunderbird.desktop" ];
        "x-scheme-handler/net.thunderbird" = [ "thunderbird.desktop" ];
        "message/rfc822" = [ "thunderbird.desktop" ];
        "application/mbox" = [ "thunderbird.desktop" ];
        "application/x-extension-eml" = [ "thunderbird.desktop" ];
        "image/png" = [ "org.gnome.Loupe.desktop" ];
        "image/jpeg" = [ "org.gnome.Loupe.desktop" ];
        "image/gif" = [ "org.gnome.Loupe.desktop" ];
        "image/webp" = [ "org.gnome.Loupe.desktop" ];
        "image/svg+xml" = [ "org.gnome.Loupe.desktop" ];
        "image/bmp" = [ "org.gnome.Loupe.desktop" ];
      };
    };
  };
}
