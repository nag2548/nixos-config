{ ... }:

{
  programs = {
    firefox = {
      enable = true;

      languagePacks = [
        "en-US"
        "de"
      ];

      policies = {
        DisableTelemetry = true;
      };
    };
  };
}
