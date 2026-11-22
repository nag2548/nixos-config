{
  programs.thunderbird = {
    enable = true;
    policies = {
      DisableTelemetry = true;
    };
    settings = {
      "intl.regional_prefs.use_os_locales" = true;
      "mail.mdn.report.enabled" = false;
      "mail.mdn.report.not_in_to_cc" = 2;
      "mail.mdn.report.outside_domain" = 2;
      "mail.mdn.report.other" = 2;
      "network.cookie.cookieBehavior" = 5;
      "mailnews.start_page.enabled" = false;
      "mail.provider.enabled" = false;
      "mailnews.auto_config.fetchFromISP.enabled" = false;
      "datareporting.healthreport.uploadEnabled" = false;
      "datareporting.policy.dataSubmissionEnabled" = false;
      "mail.collect_email_address_outgoing" = false;
      "calendar.alarms.playsound" = false;
      "calendar.week.start" = 1;
      "calendar.view.daystarthour" = 6;
      "calendar.view.dayendhour" = 24;
      "calendar.view.visiblehours" = 18;
      "mail.chat.play_sound" = false;
      "mail.shell.checkDefaultClient" = false;
      "mail.dark-reader.enabled" = false;
      "mailnews.message_display.disable_remote_image" = true;
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
      aliases = [ "login@grabmair.me" ];
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
        color = "#cba6f7";
      };
    };
    "shared" = {
      remote = {
        type = "caldav";
        url = "https://calendar.peeraten.net/shared/calendar/";
        userName = "shared";
      };
      thunderbird = {
        enable = true;
        color = "#fab387";
      };
    };
    "holidays" = {
      remote = {
        type = "http";
        url = "https://www.feiertage-deutschland.de/kalender-download/ics/feiertage-deutschland.ics";
        userName = "";
      };
      thunderbird = {
        enable = true;
        color = "#f38ba8";
        readOnly = true;
      };
    };
  };
}
