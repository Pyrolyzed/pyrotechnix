{
  pkgs,
  lib,
  ...
}:

{
  vim = {
    theme = {
      enable = true;
      name = "catppuccin";
      style = "macchiato";
    };

    assistant.copilot = {
      enable = true;
      cmp.enable = true;
    };

    options = {
      smartindent = true;
      magic = true;
      shiftround = true;
      expandtab = true;
      tabstop = 4;
      shiftwidth = 4;
    };

    statusline.lualine.enable = true;
    telescope.enable = true;
    autocomplete.nvim-cmp.enable = true;
    autopairs.nvim-autopairs.enable = true;

    lsp = {
      formatOnSave = true;
    };

    languages = {
      enableFormat = true;
      enableLSP = true;
      enableTreesitter = true;
      bash.enable = true;
      nix = {
        enable = true;
        format.type = "nixfmt";
        lsp = {
          server = "nixd";
        };
      };
      ts.enable = true;
      rust.enable = true;
      clang.enable = true;
      python.enable = true;
      html.enable = true;
    };
  };
}
