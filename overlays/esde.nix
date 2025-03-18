{
  pkgs-stable,
  ...
}:
{
  # Fix for ES-DE not building.
  nixpkgs.overlays = [
    (final: prev: {
      emulationstation-de = prev.emulationstation-de.override {
        inherit (pkgs-stable) icu libgit2;
      };
    })
  ];
}
