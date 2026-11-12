{
  programs.opencode = {
    enable = true;
    mutableSettings = true;
    cli = {
      attention.notifications = true;
      session.thinking = "show";
    };
    settings = {
      update = "disable";
      plugins = [ "opencode-notifications" ];
    };
  };
}
