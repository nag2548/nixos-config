{ config, username, ... }:
{
  sops.secrets.syncthing-admin-password.owner = username;

  services.syncthing = {
    enable = true;
    user = username;
    group = "users";
    dataDir = "/home/${username}";
    openDefaultPorts = true;
    guiPasswordFile = config.sops.secrets.syncthing-admin-password.path;

    settings = {
      options.urAccepted = -1;
      gui.user = "syncthing";
    };
  };
}
