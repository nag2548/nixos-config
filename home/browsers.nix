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
        OfferToSaveLogins = false;
        DownloadDirectory = "\${home}/downloads";
        AutofillAddressEnabled = false;
        AutofillCreditCardEnabled = false;
      };
    };

    chromium = {
      enable = true;
    };
  };
}
