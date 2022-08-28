{pkgs, ...} :

{
  imports = (import ./programs) ++ (import ./services);

  home = {
    packages = with pkgs; [
      neofetch
      killall
      htop
    ];
    stateVersion = "22.05";
  };
}

