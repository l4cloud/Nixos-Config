{ pkgs, config, lib, ...}:

{

  # DE & DM setup
  programs.hyprland.enable = true;
  services.displayManager.ly.enable = true;
  services.displayManager.ly.settings = {
    animation = "colormix";
    hide_borders = true;
    session_log = ".cache/ly/session.log";
  };

  # Audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services.pulseaudio.enable = false;

  # Laptop lid: suspend on battery, stay awake when docked or on AC
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";              # battery → sleep
    HandleLidSwitchExternalPower = "ignore";  # plugged in → stay awake
    HandleLidSwitchDocked = "ignore";         # docked/monitors → stay awake
  };

  # System-level lid handler: turn backlight off/on independently of compositor
  # Works at TTY, Ly login screen, and any DE/WM
  services.acpid.enable = true;
  services.acpid.handlers.lid = {
    event = "button/lid.*";
    action = ''
      state=$(${pkgs.gnugrep}/bin/grep -o 'open\|closed' /proc/acpi/button/lid/*/state)
      if [ "$state" = "closed" ]; then
        ${pkgs.brightnessctl}/bin/brightnessctl set 0
      else
        ${pkgs.brightnessctl}/bin/brightnessctl set 100%
      fi
    '';
  };

  # Misc Services
  services.printing.enable = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Graphics
  hardware.graphics.enable = true;

  # XDG
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
}
