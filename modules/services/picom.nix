{ lib, config, ... }: with lib;
{
  options.custom.services.picom.enable = mkEnableOption "Picom Compositor";

  config = mkIf config.custom.services.picom.enable {
    services.picom = {
      enable = true;

      settings = {
        # Backend configuration
        backend = "glx";
        vsync = true;

        # Shadows
        shadow = true;
        shadow-radius = 4;
        shadow-offset-x = -12;
        shadow-offset-y = -12;
        shadow-opacity = 0.75;
        shadow-exclude = [
            "class_g = 'i3-frame'"
            "class_g = 'i3bar'"
            "_NET_WM_STATE@:32a *= '_NET_WM_STATE_HIDDEN'"
            "_GTK_FRAME_EXTENTS@:c"
        ];
        # shadow-exclude-reg = "bounding_shaped && !rounded_corners";

        # Fading
        fading = true;
        fade-delta = 4;
        fade-in-step = 0.03;
        fade-out-step = 0.03;

        # Transparency / Opacity
        inactive-opacity = 0.75;
        active-opacity = 0.90;
        frame-opacity = 0.80;
        inactive-opacity-override = true;

        # Blur
        blur-method = "dual_kawase";
        blur-strength = 7;
        blur-background = true;
        blur-background-frame = true;
        blur-background-fixed = true;
        #blur-kern = "11,11,11,11,11,11,11,11,11,11,11";

        # Window animations
        animation-for-open = "flyin 1.0 3";
        animation-for-unmap = "flyout 1.0 3";
        animation-stagger-time = 0.03;

        # Other settings
        use-ewmh-active-win = true;
        detect-rounded-corners = true;
        detect-client-opacity = true;
        refresh-rate = 60;
        sw-opti = true;
        unredir-if-possible = true;
        unredir-if-possible-exclude = [
            "class_g = 'i3-frame'"
        ];
      };
    };
  };
}
