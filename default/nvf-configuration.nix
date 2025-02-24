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

    options.shiftwidth = 2;

    statusline.lualine.enable = true;
    telescope.enable = true;
    autocomplete.nvim-cmp.enable = true;

    languages = {
      enableLSP = true;
      enableTreesitter = true;
      nix.enable = true;
      ts.enable = true;
      rust.enable = true;
      clang.enable = true;
      python.enable = true;
      html.enable = true;
    };
  };
}
