{ pkgs, ... }:
{
  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    cowsay
    sops
    dig
    nodejs
    python3
    gitmoji-cli
    isd
    lazygit
    lazydocker
    unzip
    inetutils
    rsync

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
    whatsapp-electron
    libreoffice
    loupe
    vlc
    calibre
    obsidian
    trezor-suite
    audacity
    gimp
    element-desktop
    slack
  ];

  programs = {
    btop.enable = true;
    fastfetch.enable = true;
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
      settings = {
        mgr = {
          linemode = "size_and_mtime";
          show_hidden = true;
          show_symlink = true;
        };
      };
      initLua = ''
        function Linemode:size_and_mtime()
        	local time = math.floor(self._file.cha.mtime or 0)
        	if time == 0 then
        		time = ""
        	elseif os.date("%Y", time) == os.date("%Y") then
        		time = os.date("%b %d %H:%M", time)
        	else
        		time = os.date("%b %d  %Y", time)
        	end

        	local size = self._file:size()
        	return string.format("%s %s", size and ya.readable_size(size) or "-", time)
        end
      '';
    };
    direnv = {
      enable = true;
      enableZshIntegration = true;
    };
    nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep-since 10d --keep 5";
      };
      flake = "$HOME/.schnee";
    };
    zathura.enable = true;
    fzf.enable = true;
    bat.enable = true;
    ripgrep.enable = true;
  };
}
