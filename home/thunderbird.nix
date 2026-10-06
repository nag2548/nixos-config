{
  programs.thunderbird = {
    enable = true;
    policies = {
      DisableTelemetry = true;
    };
    settings = {
      "general.useragent.override" = "";
      "privacy.donottrackheader.enabled" = true;
      "calendar.week.start" = 1;
      "calendar.alarms.playsound" = false;
      "mail.chat.play_sound" = false;
      "mail.shell.checkDefaultClient" = false;
      "mailnews.message_display.disable_remote_image" = false;
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

    "nadinegrabmair@yahoo.de" = {
      thunderbird.enable = true;
      realName = "Nadine Grabmair";
      address = "nadinegrabmair@yahoo.de";
      userName = "nadinegrabmair@yahoo.de";
      imap = {
        host = "imap.mail.yahoo.com";
        port = 993;
        tls.enable = true;
      };
      smtp = {
        host = "smtp.mail.yahoo.com";
        port = 465;
        tls.enable = true;
      };
    };
  };

  accounts.calendar.accounts = {
    "ngrabmair@googlemail.com" = {
      primary = true;
      remote = {
        type = "caldav";
        url = "https://apidata.googleusercontent.com/caldav/v2/ngrabmair@googlemail.com/events";
        userName = "ngrabmair@googlemail.com";
      };
      thunderbird.enable = true;
    };
  };
}
