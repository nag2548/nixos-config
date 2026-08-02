{ username, ... }:

{
  virtualisation.docker = {
    enable = true;

    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  users = {
    users.${username} = {
      extraGroups = [
        "docker"
      ];
    };
  };
}
