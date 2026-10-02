{ pkgs, lib, ... }:
let
  colorfulLoop = pkgs.adi1090x-plymouth-themes.override {
    selected_themes = [ "colorful_loop" ];
  };

  logoBlock = pkgs.writeText "logo_block" ''
    logo_image = Image("logo.png");
    logo_sprite = Sprite(logo_image);
    logo_sprite.SetX(screen.half.w - logo_image.GetWidth() / 2);
    logo_sprite.SetY(flyingman_sprite.GetY() + flyingman_image[0].GetHeight() + 32);
  '';

  colorfulLoopLogo = pkgs.stdenvNoCC.mkDerivation {
    name = "colorful_loop_logo-plymouth-theme";

    nativeBuildInputs = [ pkgs.resvg ];

    logoSvg = pkgs.fetchurl {
      url = "https://brand.nixos.org/logos/nixos-logo-white-flat-white-regular-horizontal-recommended.svg";
      sha256 = "sha256-+dHxXl6D8kdzHE6uQQ4Z1kpr5vZ04ttQOE/QMrSiQhY=";
    };

    dontUnpack = true;

    buildCommand = ''
      themeDir="$out/share/plymouth/themes/colorful_loop_logo"
      mkdir -p "$themeDir"

      cat >"$themeDir/colorful_loop_logo.plymouth" <<EOF
      [Plymouth Theme]
      Name=colorful_loop_logo
      Description=colorful loop with a static NixOS logo below the spinner
      ModuleName=script

      [script]
      ImageDir=$themeDir
      ScriptFile=$themeDir/colorful_loop_logo.script
      EOF

      sed "/Plymouth\.SetRefreshFunction (refresh_callback);/r ${logoBlock}" \
        ${colorfulLoop}/share/plymouth/themes/colorful_loop/colorful_loop.script \
        > "$themeDir/colorful_loop_logo.script"

      for f in ${colorfulLoop}/share/plymouth/themes/colorful_loop/progress-*.png; do
        ln -s "$f" "$themeDir/"
      done

      resvg --width 600 "$logoSvg" "$themeDir/logo.png"
    '';
  };
in
{
  boot = {
    plymouth = {
      enable = true;
      theme = lib.mkForce "colorful_loop_logo";
      themePackages = [ colorfulLoopLogo ];
    };

    # Enable "Silent boot"
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "rd.udev.log_level=3"
      "rd.systemd.show_status=auto"
    ];

    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed
    loader.timeout = 0;
  };
}
