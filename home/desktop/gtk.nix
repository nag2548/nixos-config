{ config, ... }:
{
  gtk = {
    enable = true;
    # theme = {
    #   name = "catppuccin-mocha-mauve-standard";
    #   package = pkgs.catppuccin-gtk.override {
    #     variant = "mocha";
    #     accents = [ "mauve" ];
    #   };
    # };
    # iconTheme = {
    #   name = "Papirus-Dark";
    #   package = pkgs.papirus-icon-theme;
    # };
    # font = {
    #   name = "Inter";
    #   size = 10;
    # };
    gtk3 = {
      bookmarks = [
        "file://${config.xdg.userDirs.download}"
        "file://${config.xdg.userDirs.documents}"
        "file:///mnt/documents/consume"
      ];
    };
  };
}
