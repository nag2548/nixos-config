{ username, ... }:
{
  services.syncthing = {
    enable = true;

    group = "users";
    user = username;
    dataDir = "/home/${username}";

    openDefaultPorts = true;
    overrideDevices = true;
    overrideFolders = true;

    settings = {
      options.urAccepted = -1;
      gui.user = "syncthing";
    };
  };
}
