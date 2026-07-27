{ pkgs, ... }:

{
  programs = {
    firefox.enable = true;

    git = {
      enable = true;
      config = {
        init = {
          defaultBranch = "main";
        };
      };
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        rebuild = "sudo nixos-rebuild switch -I nixos-config=/home/nadine/git/nixos/configuration.nix";
      };
      histSize = 10000;

      ohMyZsh = {
        enable = true;
        plugins = [
          "git"
          "python"
          "man"
          "docker"
          "docker-compose"
        ];
        customPkgs = [
          pkgs.nix-zsh-completions
        ];
      };
    };

    _1password.enable = true;
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ "nadine" ];
    };

    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      viAlias = true;
      configure = {
        customRC = ''
          set number
        '';
      };
    };

    starship = {
      enable = true;
    };

    steam = {
      enable = true;
    };

    tmux = {
      enable = true;
      clock24 = true;
      plugins = with pkgs.tmuxPlugins; [
        sensible
        yank
        vim-tmux-navigator
      ];
    };
  };
}
