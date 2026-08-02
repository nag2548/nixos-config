{ pkgs, username, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    defaultUserShell = pkgs.zsh;

    users.${username} = {
      isNormalUser = true;
      uid = 1000;

      extraGroups = [
        "networkmanager"
        "wheel"
      ];
    };
  };
}
