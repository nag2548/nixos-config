let
  moz = short: "https://addons.mozilla.org/firefox/downloads/latest/${short}/latest.xpi";
in
{
  # Updates & Background Services
  AppAutoUpdate = false;
  BackgroundAppUpdate = false;

  # Feature Disabling
  DisableBuiltinPDFViewer = false;
  DisableFirefoxStudies = true;
  DisableFirefoxAccounts = true;
  DisableFirefoxScreenshots = true;
  DisableForgetButton = true;
  DisableMasterPasswordCreation = true;
  DisableProfileImport = true;
  DisableProfileRefresh = true;
  DisableSetDesktopBackground = true;
  DisablePocket = true;
  DisableTelemetry = true;
  DisableFormHistory = true;
  DisablePasswordReveal = false;

  # Access Restrictions
  BlockAboutConfig = false;
  BlockAboutProfiles = false;
  BlockAboutSupport = false;

  # UI and Behavior
  DisplayMenuBar = "never";
  DisplayBookmarksToolbar = "always";
  DontCheckDefaultBrowser = true;
  HardwareAcceleration = true;
  OfferToSaveLogins = false;
  DownloadDirectory = "\${home}/Downloads";

  AutofillAddressEnabled = false;
  AutofillCreditCardEnabled = false;

  ExtensionSettings = {
    "*".installation_mode = "blocked";

    "uBlock0@raymondhill.net" = {
      install_url = moz "ublock-origin";
      installation_mode = "force_installed";
      updates_disabled = true;
      private_browsing = true;
      default_area = "navbar";
    };

    "jid1-MnnxcxisBPnSXQ@jetpack" = {
      install_url = moz "privacy-badger17";
      installation_mode = "force_installed";
      updates_disabled = true;
      default_area = "menupanel";
    };

    "sponsorBlocker@ajay.app" = {
      install_url = moz "sponsorblock";
      installation_mode = "force_installed";
      updates_disabled = true;
      default_area = "menupanel";
    };

    "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" = {
      install_url = moz "return-youtube-dislikes";
      installation_mode = "force_installed";
      updates_disabled = true;
      default_area = "menupanel";
    };

    "FirefoxColor@mozilla.com" = {
      install_url = moz "firefox-color";
      installation_mode = "force_installed";
      updates_disabled = true;
      default_area = "menupanel";
    };

    "{d634138d-c276-4fc8-924b-40a0ea21d284}" = {
      install_url = moz "1password-x-password-manager";
      installation_mode = "force_installed";
      updates_disabled = true;
      private_browsing = true;
      default_area = "navbar";
    };
  };
}
