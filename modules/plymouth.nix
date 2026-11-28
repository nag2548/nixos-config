{ pkgs, lib, ... }:
let
  pixels = pkgs.adi1090x-plymouth-themes.override {
    selected_themes = [ "pixels" ];
  };

  logoBlock = pkgs.writeText "logo_block" ''
    logo_image = Image("logo.png");
    logo_sprite = Sprite(logo_image);
    logo_sprite.SetX(screen.half.w - logo_image.GetWidth() / 2);
    preferred_y = flyingman_sprite.GetY() + flyingman_image[0].GetHeight() + 32;
    max_y = screen.h - logo_image.GetHeight() - 100;
    logo_sprite.SetY(Math.Min(preferred_y, max_y));
  '';

  pixelsLogo = pkgs.stdenvNoCC.mkDerivation {
    name = "pixels_logo-plymouth-theme";

    nativeBuildInputs = [ pkgs.resvg ];

    logoSvg = pkgs.fetchurl {
      url = "https://brand.nixos.org/logos/nixos-logo-rainbow-gradient-white-regular-horizontal-recommended.svg";
      sha256 = "sha256-vHWMyfoqjW1I0GIPuQcomHBY0OlWyQALrJCZuVQxKAU=";
    };

    dontUnpack = true;

    buildCommand = ''
      themeDir="$out/share/plymouth/themes/pixels_logo"
      mkdir -p "$themeDir"

      cat >"$themeDir/pixels_logo.plymouth" <<EOF
      [Plymouth Theme]
      Name=pixels_logo
      Description=pixels with a static NixOS logo below the animation
      ModuleName=script

      [script]
      ImageDir=$themeDir
      ScriptFile=$themeDir/pixels_logo.script
      EOF

      sed "/Plymouth\.SetRefreshFunction (refresh_callback);/r ${logoBlock}" \
        ${pixels}/share/plymouth/themes/pixels/pixels.script \
        > "$themeDir/pixels_logo.script"

      for f in ${pixels}/share/plymouth/themes/pixels/progress-*.png; do
        ln -s "$f" "$themeDir/"
      done

      resvg --width 320 "$logoSvg" "$themeDir/logo.png"
    '';
  };
in
{
  boot = {
    plymouth = {
      enable = true;
      theme = lib.mkForce "pixels_logo";
      themePackages = [ pixelsLogo ];
    };

    # Enable "Silent boot"
    consoleLogLevel = 3;
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
