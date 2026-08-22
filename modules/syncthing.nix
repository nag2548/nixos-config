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

      devices = {
        "ubuntu" = {
          id = "LF3A236-XRDRLGO-4PW6VLU-6W7LBOH-522PQKM-QMO72WT-4BF75QY-4CYSEAC";
        };
        "mobiltelefon" = {
          id = "FWM4MEY-P7AQRNA-LZWFA6V-PDFM2K2-CWKP5Y7-JYRCEFA-ZYSAOZL-CVFSTQM";
        };
      };

      folders =
        let
          dir = config.services.syncthing.dataDir;
        in
        {
          "nexus" = {
            enable = true;
            id = "uesyu-f67hq";
            path = "${dir}/Documents/nexus";
            devices = [
              "ubuntu"
              "mobiltelefon"
            ];
            ignorePerms = true;
          };
        };
    };
  };
}
