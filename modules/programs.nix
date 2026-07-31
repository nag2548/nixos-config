{ ... }:

{
  programs = {
    zsh.enable = true;

    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      viAlias = true;
    };

    steam = {
      enable = true;
    };

    _1password.enable = true;
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ "nadine" ];
    };
  };
}
