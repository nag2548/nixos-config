{ pkgs, ... }:

{
  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    cowsay
    sops

    jetbrains.idea
    protonmail-bridge-gui
    sone
    portfolio
    nextcloud-client
    citrix-workspace
    signal-desktop
    telegram-desktop
    karere
    libreoffice

    nodejs
    temurin-bin-25
    python3
    gitmoji-cli
  ];

  programs = {
    btop.enable = true;

    vesktop = {
      enable = true;
      vencord.settings = {
        autoUpdate = false;
        autoUpdateNotification = false;
        notifyAboutUpdates = false;
        plugins = {
          FakeNitro.enabled = true;
          ClearURLs.enabled = true;
          FixYoutubeEmbeds.enabled = true;
          SilentTyping.enabled = true;
          YoutubeAdblock.enabled = true;
        };
      };
    };
  };
}
