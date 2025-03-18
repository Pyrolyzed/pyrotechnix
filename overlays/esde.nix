{
  pkgs,
  pkgs-stable,
  ...
}:
{
  # Temporary fix for https://github.com/NixOS/nixpkgs/issues/380330
  nixpkgs.overlays = [
    (final: prev: {
      # emulationstation-de = pkgs-stable.emulationstation-de;
      emulationstation-de = prev.emulationstation-de.overrideAttrs (old: {
        buildInputs = map (
          pkg:
          if pkg == pkgs.icu then
            pkgs-stable.icu
          else if pkg == pkgs.libgit2 then
            pkgs-stable.libgit2
          else
            pkg
        ) old.buildInputs;
      });
    })
  ];
}
