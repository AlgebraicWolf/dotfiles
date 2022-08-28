{ config, lib, pkgs, ...} :

{
  services = {
    upower.enable = true;

    dbus.enable = true;

    xserver = {
      enable = true;
      layout = "us,ru";
      
      libinput = {
        enable = true;
	touchpad.disableWhileTyping = true;
      };

      displayManager.defaultSession = "none+xmonad";
      
      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
      };

      xkbOptions = "grp:alt_shift_toggle";
    };
  };

  systemd.services.upower.enable = true;
}
