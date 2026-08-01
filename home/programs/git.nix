{ ... }:

{
  programs.git = {
    enable = true;
    lfs.enable = true;

    settings = {
      user = {
        name = "Nadine Grabmair";
        email = "nadine.grabmair@gmx.de";
      };

      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };
  };
}
