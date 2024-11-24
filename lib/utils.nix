{ lib, ... }:

let 
  inherit (lib) toLower replaceStrings;
in {
  toOneWord = string: replaceStrings [" "] [""] string;
}
