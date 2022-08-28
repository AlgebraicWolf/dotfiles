{pkgs, ...}:

{
  programs = {
    alacritty = {
      enable = true;
      settings = {
        font = rec {
          normal.family = "Iosevka";
          bold = { style = "Bold"; };
          size = 12;
        };
      };
    };
  };
}
