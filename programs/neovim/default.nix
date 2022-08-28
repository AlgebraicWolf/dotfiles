{pkgs, ...}:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    withNodeJs = true;

    plugins = with pkgs.vimPlugins; [
      # Syntax highlight
      vim-nix

      # Quality of life
      vim-lastplace
      auto-pairs
      vim-gitgutter
      nvim-comment

      # File Tree
      nerdtree

      # Customization
      vim-airline
      indent-blankline-nvim
    ];

    coc = {
      enable = true;

      package = pkgs.vimUtils.buildVimPluginFrom2Nix {
        pname = "coc.nvim";
        version = "2022-08-21";
        src = pkgs.fetchFromGitHub {
          owner = "neoclide";
          repo = "coc.nvim";
          rev = "95aebf4";
          sha256 = "sha256-Ljwe4VvbMcLUYlTmOgwNSTTeIjNaTdb7aMQFlUYhr+I=";
        };
        meta.homepage = "https://github.com/neoclide/coc.nvim/";
      };   

      settings = {
        "suggest.noselect" = true;
        "suggest.enablePreview" = true;
        "suggest.enablePreselect" = false;
        "suggest.disableKind" = true;
        languageserver = {
          haskell = {
            command = "haskell-language-server-wrapper";
            args = [ "--lsp" ];
            filetypes = [ "haskell" "lhaskell" ];
          };
        };
      };
    };

    extraConfig = ''
      syntax enable;

      highlight Comment cterm=italic gui=italic

      set number

      set smartindent
      set tabstop=2
      set expandtab
      set shiftwidth=2

      nmap <F6> :NERDTreeToggle<CR>
    '';
  };
}
