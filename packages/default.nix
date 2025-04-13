{
  inputs,
  pkgs,
  ...
}:
{
  citron = pkgs.callPackage ./citron.nix { inherit pkgs; };
  neovim-pyro =
    (inputs.nvf.lib.neovimConfiguration {
      inherit pkgs;
      modules = [
        ./neovim-pyro
      ];
      extraSpecialArgs = {
        dots = "/persist/home/pyro/Projects/pyrotechnix";
      };
    }).neovim;
}
