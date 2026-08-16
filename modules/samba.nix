{ config, pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      cifs-utils
    ];
  };

  sops = {
    secrets."samba-truenas/username" = { };
    secrets."samba-truenas/password" = { };
    templates."samba-truenas".content = ''
      username=${config.sops.placeholder."samba-truenas/username"}
      password=${config.sops.placeholder."samba-truenas/password"}
    '';
  };

  fileSystems."/mnt/documents" = {
    device = "//192.168.100.31/documents";
    fsType = "cifs";

    options =
      let
        # this line prevents hanging on network split
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
      in
      [ "${automount_opts},credentials=${config.sops.templates.samba-truenas.path},uid=1000,gid=100" ];
  };
}
