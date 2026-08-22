{ config, username, ... }:
{
  sops.secrets.syncthing-admin-password.owner = "root";

  services.syncthing = {
    enable = true;
    user = username;
    group = "users";
    dataDir = "/home/${username}";
    openDefaultPorts = true;

    settings = {
      options.urAccepted = -1;
      guiPasswordFile = config.sops.secrets.syncthing-admin-password.path;
      gui.user = "syncthing";
    };
  };
}
