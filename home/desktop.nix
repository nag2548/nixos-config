{ pkgs, inputs, ... }:

{
  imports = [ inputs.noctalia.homeModules.default ];

  programs = {
    noctalia = {
      enable = true;
      systemd.enable = true;
      settings = {
        theme = {
          mode = "dark";
          source = "builtin";
          builtin = "Catppuccin";
        };
      };
    };
  };

  services = {
    polkit-gnome.enable = true;
  };

  home.packages = with pkgs; [
    swaybg
    xwayland-satellite
  ];

  xdg.configFile."niri/config.kdl".source =
    pkgs.runCommand "niri-config-checked"
      {
        nativeBuildInputs = [ pkgs.niri ];
      }
      ''
        niri validate --config ${./config/niri.kdl}
        cp ${./config/niri.kdl} $out
      '';
}
