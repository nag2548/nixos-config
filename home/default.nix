{ config, username, ... }:

{
  imports = [
    ./browsers.nix
    ./common.nix
    ./git.nix
    ./terminal.nix
    ./thunderbird.nix
    ./vscode.nix
    ./desktop.nix
    ./vicinae.nix
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";

  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
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
