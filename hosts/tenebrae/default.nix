{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix

    ../../modules/common.nix
    ../../modules/niri-session.nix
    ../../modules/gaming.nix
    ../../modules/users.nix
    ../../modules/samba.nix
    ../../modules/docker.nix
    ../../modules/bluetooth.nix
    ../../modules/syncthing.nix
  ];

  networking.hostName = "tenebrae";

  services = {
    xserver = {
      enable = true;
      xkb = {
        layout = "de";
        variant = "";
      };
    };
  };

  console.keyMap = "de";

  sops.secrets."wireguard-mesh/tenebrae-conf" = {
    mode = "0600";
    path = "/etc/wireguard/wg-mesh.conf";
  };

  environment.systemPackages = [ pkgs.wireguard-tools ];

  system.stateVersion = "26.05";
}
