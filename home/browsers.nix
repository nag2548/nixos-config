{ pkgs, ... }:
{
  programs = {
    firefox = {
      enable = true;

      nativeMessagingHosts = [ pkgs.kdePackages.plasma-browser-integration ];

      languagePacks = [
        "en-US"
        "de"
      ];

      policies = {
        # Updates & Background Services
        AppAutoUpdate = false;
        BackgroundAppUpdate = false;

        DisableTelemetry = true;
        DisablePocket = true;
        DisableMasterPasswordCreation = true;
        OfferToSaveLogins = false;
        DownloadDirectory = "\${home}/Downloads";
        AutofillAddressEnabled = false;
        AutofillCreditCardEnabled = false;
      };
    };

    chromium = {
      enable = true;
    };
  };
}
