{
  # programs.neovim = {
  #   enable = true;
  #   defaultEditor = true;
  #   viAlias = true;
  #   vimAlias = true;

  #   extraConfig = ''
  #     set number
  #     set cursorline
  #   '';
  # };
  programs.nvf = {
    enable = true;
    enableManpages = true;
    defaultEditor = true;

    settings.vim = {
      viAlias = true;
      vimAlias = true;

      theme = {
        enable = true;
        name = "catppuccin";
        style = "mocha";
      };

      options = {
        shiftwidth = 2;
        tabstop = 2;
        softtabstop = 2;
        expandtab = true;
        autoindent = true;
        smartindent = true;
        wrap = false;
        hlsearch = true;
        incsearch = true;
        termguicolors = true;
        cursorline = true;
      };

      lsp = {
        enable = true;
        formatOnSave = true;
        lightbulb.enable = true;
        trouble.enable = true;
        lspSignature.enable = true;
      };
    };
  };
}
