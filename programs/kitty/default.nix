{pkgs, ...}:

{
  programs = {
    kitty = {
      enable = true;
      font = {
        # package = pkgs.iosevka;
        name = "Iosevka";
        size = 12;
      };

      settings = {
        confirm_os_window_close = 0;
        bold_font = "Iosevka Bold";
        italic_font = "Iosevka Italic";
      };
    };
  };
}
