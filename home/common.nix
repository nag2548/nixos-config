{ pkgs, ... }:

{
  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    cowsay
    sops

    jetbrains.idea
    (protonmail-bridge-gui.overrideAttrs (old: {
      postFixup = (old.postFixup or "") + ''
        # Proton's autostart (--no-window) writes the raw binary path
        # (lib/bridge-gui) into ~/.config/autostart, bypassing the wrapped
        # bin entry. Wrap the raw binary too so QML/plugin env is always set.
        wrapQtApp $out/lib/bridge-gui
      '';
    }))
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
