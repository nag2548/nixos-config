{ pkgs, ... }:

{
  home.username = "nadine";
  home.homeDirectory = "/home/nadine";

  # Import files from the current configuration directory into the Nix store,
  # and create symbolic links pointing to those store files in the Home directory.

  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # Import the scripts directory into the Nix store,
  # and recursively generate symbolic links in the Home directory pointing to the files in the store.
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # misc
    cowsay

    btop
  ];

  programs = {
    git = {
      enable = true;
      lfs.enable = true;
      settings = {
        user = {
          name = "nag2548";
          email = "nadine.grabmair@gmx.de";
        };
        init.defaultBranch = "main";
        push = {
          autoSetupRemote = true;
        };
      };
    };

    vesktop = {
      enable = true;

      vencord.settings = {
        autoUpdate = true;
        autoUpdateNotification = true;
        notifyAboutUpdates = true;

        plugins = {
          ClearURLs.enabled = true;
          FixYoutubeEmbeds.enabled = true;
        };
      };
    };

    thunderbird = {
      enable = true;
    };

    firefox = {
      enable = true;
      languagePacks = [
        "en-US"
        "de"
      ];
      preferences = {
        "privacy.resistFingerprinting" = true;
      };
      policies = {
        DisableTelemetry = true;
      };
      nativeMessagingHosts.packages = with pkgs; [ kdePackages.plasma-browser-integration ];
    };
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "26.05";
}
