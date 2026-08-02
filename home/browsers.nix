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
        DisableTelemetry = true;
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
