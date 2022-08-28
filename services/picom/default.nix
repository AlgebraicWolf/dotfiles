{pkgs, ...}:

{
  services.picom = {
    enable = true;
    activeOpacity = 1.0;
    inactiveOpacity = 0.5;
    # backend = "glx";
  };
}
