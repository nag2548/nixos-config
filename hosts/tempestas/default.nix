{ username, ... }:
{
  imports = [
    ./hardware-configuration.nix

    ../../modules/common.nix
    ../../modules/kde-session.nix
    ../../modules/gaming.nix
    ../../modules/users.nix
    ../../modules/samba.nix
    ../../modules/docker.nix
    ../../modules/bluetooth.nix
    ../../modules/syncthing.nix
  ];

  networking.hostName = "tempestas";

  services = {
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "intl";
      };
    };
  };

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    age.keyFile = "/home/${username}/.config/sops/age/keys.txt";
  };

  system.stateVersion = "26.05";
}
