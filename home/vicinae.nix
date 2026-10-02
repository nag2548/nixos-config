{ inputs, pkgs, ... }:
{
  imports = [
    inputs.vicinae.homeManagerModules.default
  ];

  programs.vicinae = {
    enable = true;
    # TODO: https://github.com/vicinaehq/vicinae/issues/2040
    package = pkgs.vicinae;
    systemd = {
      enable = true;
      autoStart = true;
      environment = {
        USE_LAYER_SHELL = 1;
        OP_BIOMETRIC_UNLOCK_ENABLED = "true";
        # QSG_RHI_BACKEND = "vulkan";
      };
    };
    settings = {
      favicon_service = "twenty";
      pop_to_root_on_close = false;
      launcher_window.opacity = 0.90;
    };
  };
}
