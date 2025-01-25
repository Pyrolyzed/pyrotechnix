{ lib, ... }:
lib.extend (
  _: libprev: {
    custom = rec {
      toOneWord = string: libprev.replaceStrings [" "] [""] string;
      isEmptyList = list: (libprev.lists.compareLists libprev.compare list [ ]) == 1;
    };
  }
)
