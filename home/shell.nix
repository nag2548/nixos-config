{ pkgs, ... }:

{
  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      historySubstringSearch.enable = true;

      shellAliases = {
        rebuild = "sudo nixos-rebuild switch --flake ~/.schnee";
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
      enableZshIntegration = true;

      settings = {
        right_format = "$time";
        time.disabled = false;
        hostname.ssh_only = false;
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

    kitty = {
      enable = true;
      shellIntegration.enableZshIntegration = true;
      settings = {
        enable_audio_bell = false;
        visual_bell_duration = "1.2 ease-in linear";
        scrollback_lines = 10000;
        update_check_interval = 0;
        font_size = 11;
        font_family = "JetBrainsMono Nerd Font";
      };
      themeFile = "Catppuccin-Mocha";
    };
  };
}
