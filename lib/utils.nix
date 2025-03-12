{ lib, ... }:
lib.extend (
  _: libprev: {
    custom = {
      toOneWord = string: (builtins.replaceStrings [ " " ] [ "" ] string);
      isEmptyList = list: list == [ ];
    };
  }
)
