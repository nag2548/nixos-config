{ inputs, pkgs, ... }:
let
  unstable = import inputs.nixpkgs-unstable { inherit (pkgs.stdenv.hostPlatform) system; };
in
{
  home.username = "nadine";
  home.homeDirectory = "/home/nadine";

  # Import files from the current configuration directory into the Nix store,
  # and create symbolic links pointing to those store files in the Home directory.

  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # Import the scripts directory into the Nix store,
  # and recursively generate symbolic links in the Home directory pointing to the files in the store.
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    cowsay
    btop

    kdePackages.kate
    jetbrains.idea
    protonmail-bridge-gui
    sone
    unstable.portfolio
    nextcloud-client
    citrix_workspace
    signal-desktop
    telegram-desktop

    nodejs
    temurin-bin-25
  ];

  programs = {
    git = {
      enable = true;
      lfs.enable = true;
      settings = {
        user = {
          name = "nag2548";
          email = "nadine.grabmair@gmx.de";
        };
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
      };
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        rebuild = "sudo nixos-rebuild switch --flake /home/nadine/.schnee";
      };
      history = {
        size = 10000;
        ignoreAllDups = true;
      };

      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "python"
          "man"
          "docker"
          "docker-compose"
        ];
      };
    };

    starship = {
      enable = true;
    };

    vesktop = {
      enable = true;
      vencord.settings = {
        autoUpdate = true;
        autoUpdateNotification = true;
        notifyAboutUpdates = true;
        plugins = {
          FakeNitro.enabled = true;
          ClearURLs.enabled = true;
          FixYoutubeEmbeds.enabled = true;
        };
      };
    };

    thunderbird = {
      enable = true;
    };

    firefox = {
      enable = true;
      languagePacks = [
        "en-US"
        "de"
      ];
      policies = {
        DisableTelemetry = true;
      };
    };

    tmux = {
      enable = true;
      clock24 = true;
      mouse = true;
      plugins = with pkgs.tmuxPlugins; [
        sensible
        yank
        vim-tmux-navigator
        better-mouse-mode
      ];
    };

    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      extraConfig = ''
        set number
        set cursorline
      '';
    };

    vscode = {
      enable = true;
      package = pkgs.vscode.fhs;
      profiles.default = {
        extensions = with pkgs.vscode-extensions; [
          dracula-theme.theme-dracula
          vscodevim.vim
          yzhang.markdown-all-in-one
          jnoortheen.nix-ide
          christian-kohler.path-intellisense
        ];
        enableUpdateCheck = true;
        enableExtensionUpdateCheck = true;
        userSettings = {
          "diffEditor.ignoreTrimWhitespace" = false;
          "files.autoSave" = "afterDelay";
          "workbench.colorTheme" = "Dracula Theme";
          "vim.handleKeys" = {
            "<C-p>" = false;
            "<C-d>" = true;
            "<C-s>" = false;
            "<C-z>" = false;
          };
        };
      };
    };
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "26.05";
}
