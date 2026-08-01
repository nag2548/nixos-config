{ pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    defaultUserShell = pkgs.zsh;

    users."nadine" = {
      isNormalUser = true;
      description = "nadine";

      extraGroups = [
        "networkmanager"
        "wheel"
      ];
    };
  };
}
