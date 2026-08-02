{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/common.nix
    ../../modules/gaming.nix
    ../../modules/users.nix
    ../../modules/samba.nix
    ../../modules/docker.nix
    ../../modules/bluetooth.nix
  ];

  networking.hostName = "galanthus";

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "intl";
  };

  environment.systemPackages = with pkgs; [
    solaar
  ];

  hardware.logitech.wireless.enable = true;

  system.stateVersion = "26.05";
}
