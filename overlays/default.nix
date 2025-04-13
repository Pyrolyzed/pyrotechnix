{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./esde.nix
  ];

  nixpkgs.overlays = [
    (final: prev: {
      custom =
        (prev.custom or { })
        // (import ../packages {
          inherit (prev) pkgs;
          inherit inputs;
        });
    })
  ];
}
