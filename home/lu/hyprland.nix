{ ... }:
{
  wayland.windowManager.hyprland.settings = {
    env = [
      "QT_QPA_PLATFORMTHEME,qt6ct"
      "AQ_DRM_DEVICES,/dev/dri/card0:/dev/dri/card1"
    ];
  };
}
