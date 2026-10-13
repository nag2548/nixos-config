{
  programs.thunderbird = {
    enable = true;
    policies = {
      DisableTelemetry = true;
    };
    settings = {
      "general.useragent.override" = "";
      "privacy.donottrackheader.enabled" = true;
      "calendar.alarms.playsound" = false;
      "calendar.week.start" = 1;
      "calendar.view.visiblehours" = 14;
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
    "nextcloud-personal" = {
      primary = true;
      remote = {
        type = "caldav";
        url = "https://nextcloud.zimtix.de/remote.php/dav/calendars/nadine/personal/";
        userName = "nadine";
      };
      thunderbird = {
        enable = true;
        color = "#a6e3a1";
      };
    };
  };
}
