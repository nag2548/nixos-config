{ pkgs, ... }:

{
  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

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
  };
}
