{
  config,
  inputs,
  username,
  ...
}:

{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    ./browsers.nix
    ./common.nix
    ./git.nix
    ./shell.nix
    ./thunderbird.nix
    ./vscode.nix
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
