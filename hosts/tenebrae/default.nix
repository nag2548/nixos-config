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

  networking.hostName = "tenebrae";

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  console.keyMap = "de";

  system.stateVersion = "26.05";
}
