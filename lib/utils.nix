{ lib, pkgs, ... }:
lib.extend (
  _: libprev: {
    custom = rec {
      toOneWord = string: (builtins.replaceStrings [" "] [""] string);
      isEmptyList = list: list == [];
    };
  }
)
