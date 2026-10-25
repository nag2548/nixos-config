{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix

    ./modules/services.nix

    ../../modules/common.nix
    ../../modules/niri-session.nix
    ../../modules/gaming.nix
    ../../modules/users.nix
    ../../modules/samba.nix
    ../../modules/docker.nix
    ../../modules/bluetooth.nix
    ../../modules/syncthing.nix
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

  system.stateVersion = "26.05";
}
