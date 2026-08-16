{ pkgs, ... }:

{
  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    cowsay
    sops
    nodejs
    temurin-bin-25
    python3
    gitmoji-cli
    isd
    lazygit

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
    # Citrix's WebKit UI (PrimaryAuthManager/selfservice) calls
    # gdk_x11_window_get_xid unconditionally, which crashes the login window
    # when GTK picks the Wayland backend (the niri session exports
    # GDK_BACKEND=wayland,x11). Force the X11 backend for every Citrix binary.
    (pkgs.citrix-workspace.overrideAttrs (old: {
      postFixup = (old.postFixup or "") + ''
        for prog in selfservice wfica adapter PrimaryAuthManager AuthManagerDaemon ServiceRecord util/configmgr util/conncenter util/ctx_rehash util/ctxwebhelper; do
          wrapProgram "$out/opt/citrix-icaclient/$prog" --set GDK_BACKEND x11
        done
      '';
    }))
    signal-desktop
    telegram-desktop
    libreoffice
    loupe
    vlc
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
    yazi = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
