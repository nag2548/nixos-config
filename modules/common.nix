{
  pkgs,
  username,
  inputs,
  ...
}:

{
  imports = [ inputs.noctalia-greeter.nixosModules.default ];

  nixpkgs.overlays = [
    (final: prev: {
      stable = import inputs.nixpkgs-stable {
        inherit (prev.stdenv.hostPlatform) system;
        config.allowUnfree = true;
      };
    })
  ];

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    substituters = [
      "https://cache.keyruu.de"
      "https://cache.nixos.org"
      "https://vicinae.cachix.org"
      "https://noctalia.cachix.org"
    ];
    trusted-public-keys = [
      "cache.keyruu.de:BifJnHe/XQhZmmFwLSZttthsXT4u2/L4aeo0k9zV+Kc="
      "nixpkgs.cachix.org-1:q91R6hxbwFvDqTSDKwDAV4T5PxqXGxswD8vhONFMeOE="
      "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 20;
    };
    efi.canTouchEfiVariables = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  time.timeZone = "Europe/Berlin";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "de_DE.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "de_DE.UTF-8";
    };
  };

  networking.networkmanager.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];

  environment = {
    systemPackages = with pkgs; [
      nixd
      nixfmt
      wl-clipboard
    ];
  };

  security.rtkit.enable = true;

  services = {
    printing.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    power-profiles-daemon.enable = true;
    upower.enable = true;
    gvfs.enable = true;
  };

  programs = {
    zsh.enable = true;

    _1password.enable = true;
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ username ];
    };

    niri.enable = true;

    noctalia-greeter = {
      enable = true;
      settings = {
        cursor = {
          path = "${pkgs.catppuccin-cursors.mochaDark}/share/icons";
          theme = "catppuccin-mocha-dark-cursors";
          size = 24;
        };
        appearance = {
          scheme = "Synced";
          theme_mode = "dark";
          hide_logo = true;
          palette = {
            primary = "#cba6f7";
            on_primary = "#1e1e2e";
            secondary = "#89b4fa";
            on_secondary = "#1e1e2e";
            tertiary = "#94e2d5";
            on_tertiary = "#1e1e2e";
            error = "#f38ba8";
            on_error = "#1e1e2e";
            surface = "#1e1e2e";
            on_surface = "#cdd6f4";
            surface_variant = "#313244";
            on_surface_variant = "#bac2de";
            outline = "#45475a";
            shadow = "#11111b";
            hover = "#94e2d5";
            on_hover = "#1e1e2e";
          };
          wallpaper = {
            path = ../home/themes/bg.png;
            fill_mode = "crop";
          };
        };
      };
    };
  };
}
