{ pkgs, ... }:

{
  # Install firefox.
  programs.firefox.enable = true;

  programs.zsh = {
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

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "nadine" ];
  };

  programs.neovim = {
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

  programs.starship = {
    enable = true;
  };
}
