{
  pkgs,
  pkgs-stable,
  ...
}:
{
  nixpkgs.overlays = [
    (self: super: {
      # Temporary fix for https://github.com/NixOS/nixpkgs/issues/380330
      pkgs.overlays = [
        (self: super: {
          libgit2 = pkgs-stable.libgit2;
        })
      ];
    })
  ];
}
