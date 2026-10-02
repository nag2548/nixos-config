{ pkgs, lib, ... }:
let
  colorfulLoop = pkgs.adi1090x-plymouth-themes.override {
    selected_themes = [ "colorful_loop" ];
  };

  themeScript = pkgs.writeText "colorful_loop_logo.script" ''
    ## Based on colorful_loop by Aditya Shakya (@adi1090x).
    ## Modifications: render a static logo image below the spinner animation.

    screen.w = Window.GetWidth(0);
    screen.h = Window.GetHeight(0);
    screen.half.w = Window.GetWidth(0) / 2;
    screen.half.h = Window.GetHeight(0) / 2;

    question = null;
    answer = null;

    message = null;

    bullets = null;
    prompt = null;
    bullet.image = Image.Text("*", 1, 1, 1);

    state.status = "play";
    state.time = 0.0;

    # cycle through all images
    for (i = 0; i < 89; i++)
      flyingman_image[i] = Image("progress-" + i + ".png");
    flyingman_sprite = Sprite();

    # spinner position (vertically centered)
    anim_y = Window.GetY() + (Window.GetHeight(0) / 2 - flyingman_image[0].GetHeight() / 2);
    flyingman_sprite.SetX(Window.GetX() + (Window.GetWidth(0) / 2 - flyingman_image[0].GetWidth() / 2));
    flyingman_sprite.SetY(anim_y);

    progress = 0;

    # static logo below the spinner
    logo_image = Image("logo.png");
    logo_sprite = Sprite(logo_image);
    logo_sprite.SetX(screen.half.w - logo_image.GetWidth() / 2);
    logo_sprite.SetY(anim_y + flyingman_image[0].GetHeight() + 32);

    fun refresh_callback ()
      {
        flyingman_sprite.SetImage(flyingman_image[Math.Int(progress / 2) % 89]);
        progress++;
      }

    Plymouth.SetRefreshFunction (refresh_callback);

    fun DisplayQuestionCallback(prompt, entry) {
        question = null;
        answer = null;

        if (entry == "")
            entry = "<answer>";

        question.image = Image.Text(prompt, 1, 1, 1);
        question.sprite = Sprite(question.image);
        question.sprite.SetX(screen.half.w - question.image.GetWidth() / 2);
        question.sprite.SetY(screen.h - 4 * question.image.GetHeight());

        answer.image = Image.Text(entry, 1, 1, 1);
        answer.sprite = Sprite(answer.image);
        answer.sprite.SetX(screen.half.w - answer.image.GetWidth() / 2);
        answer.sprite.SetY(screen.h - 2 * answer.image.GetHeight());
    }
    Plymouth.SetDisplayQuestionFunction(DisplayQuestionCallback);

    fun DisplayPasswordCallback(nil, bulletCount) {
        state.status = "pause";
        totalWidth = bulletCount * bullet.image.GetWidth();
        startPos = screen.half.w - totalWidth / 2;

        prompt.image = Image.Text("Enter Password", 1, 1, 1);
        prompt.sprite = Sprite(prompt.image);
        prompt.sprite.SetX(screen.half.w - prompt.image.GetWidth() / 2);
        prompt.sprite.SetY(screen.h - 4 * prompt.image.GetHeight());

        bullets = null;
        for (i = 0; i < bulletCount; i++) {
            bullets[i].sprite = Sprite(bullet.image);
            bullets[i].sprite.SetX(startPos + i * bullet.image.GetWidth());
            bullets[i].sprite.SetY(screen.h - 2 * bullet.image.GetHeight());
        }
    }
    Plymouth.SetDisplayPasswordFunction(DisplayPasswordCallback);

    fun DisplayNormalCallback() {
        state.status = "play";
        bullets = null;
        prompt = null;
        message = null;
        question = null;
        answer = null;
    }
    Plymouth.SetDisplayNormalFunction(DisplayNormalCallback);

    fun MessageCallback(text) {
        message.image = Image.Text(text, 1, 1, 1);
        message.sprite = Sprite(message.image);
        message.sprite.SetPosition(screen.half.w - message.image.GetWidth() / 2, message.image.GetHeight());
    }
    Plymouth.SetMessageFunction(MessageCallback);
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

      cp ${themeScript} "$themeDir/colorful_loop_logo.script"

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
