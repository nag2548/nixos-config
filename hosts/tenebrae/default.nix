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

  networking.hostName = "tenebrae";

  systemd.services.sync-windows-esp = {
    description = "Copy the Windows bootloader onto the NixOS ESP";
    after = [ "local-fs.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RuntimeDirectory = "windows-esp";
      ExecStart = [
        "${pkgs.util-linux}/bin/mount --read-only /dev/disk/by-partuuid/28df16b3-c9f1-4b33-bd03-f4ceca7d468f /run/windows-esp"
        "${pkgs.coreutils}/bin/mkdir --parents /boot/EFI"
        "${pkgs.coreutils}/bin/rm --recursive --force /boot/EFI/Microsoft"
        "${pkgs.coreutils}/bin/cp --recursive --no-target-directory /run/windows-esp/EFI/Microsoft /boot/EFI/Microsoft"
        "${pkgs.util-linux}/bin/umount /run/windows-esp"
      ];
    };
  };

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
