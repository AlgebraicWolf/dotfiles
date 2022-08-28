{pkgs, ...}:

let
  bars = builtins.readFile ./docky/bars.ini;
  colors = builtins.readFile ./docky/colors.ini;
  modules = builtins.readFile ./docky/modules.ini;
  user_modules = builtins.readFile ./docky/user_modules.ini;
  xmonad = ''
    [module/xmonad]
    type = custom/script
    exec = ${pkgs.xmonad-log}/bin/xmonad-log

    tail = true
  '';
in
{
    services.polybar = {
    enable = true;
    config = ./docky/config.ini;
    extraConfig = bars + colors + modules + user_modules + xmonad;
    script = ''
      polybar main &
    '';
  };
}
