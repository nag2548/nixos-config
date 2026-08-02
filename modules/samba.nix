{
  config,
  pkgs,
  username,
  ...
}:

{
  environment = {
    systemPackages = with pkgs; [
      cifs-utils
    ];
  };

  fileSystems."/mnt/documents" = {
    device = "//192.168.100.31/documents";
    fsType = "cifs";

    options =
      let
        # this line prevents hanging on network split
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
        uid = toString config.users.users.${username}.uid;
        gid = toString config.users.groups.users.gid;
      in
      [ "${automount_opts},credentials=/etc/nixos/smb-secrets,uid=${uid},gid=${gid}" ];
  };
}
