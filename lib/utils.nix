{ lib, ... }:
lib.extend (
  _: libprev: {
    custom = rec {
      toOneWord = string: libprev.replaceStrings [" "] [""] string;
    };
  }
)
