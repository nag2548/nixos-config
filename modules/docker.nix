{
  virtualisation.docker = {
    enable = true;

    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  users = {
    users."nadine" = {
      extraGroups = [
        "docker"
      ];
    };
  };
}
