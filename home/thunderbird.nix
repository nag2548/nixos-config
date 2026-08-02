{
  programs.thunderbird = {
    enable = true;
    policies = {
      DisableTelemetry = true;
    };
    settings = {
      "general.useragent.override" = "";
      "privacy.donottrackheader.enabled" = true;
    };
    languagePacks = [
      "en-US"
      "de"
    ];
    profiles."default" = {
      isDefault = true;
    };
  };

  accounts.email.accounts = {
    "nadine@grabmair.me" = {
      primary = true;
      thunderbird.enable = true;
      realName = "Nadine Grabmair";
      address = "nadine@grabmair.me";
      userName = "nadine@grabmair.me";

      imap = {
        host = "127.0.0.1";
        port = 1143;
        tls.useStartTls = true;
      };
      smtp = {
        host = "127.0.0.1";
        port = 1025;
        tls.useStartTls = true;
      };
    };
  };
}
