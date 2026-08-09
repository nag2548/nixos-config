{ pkgs, username, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ./modules/services.nix

    ../../modules/common.nix
    ../../modules/gaming.nix
    ../../modules/users.nix
    ../../modules/samba.nix
    ../../modules/docker.nix
    ../../modules/bluetooth.nix
  ];

  networking.hostName = "galanthus";

  services = {
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "intl";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    solaar
  ];
  hardware.logitech.wireless.enable = true;

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    age.keyFile = "/home/${username}/.config/sops/age/keys.txt";
  };

  system.stateVersion = "26.05";
}
