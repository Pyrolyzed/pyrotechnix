{ config, lib, pkgs, user, ... }:
let 
  cfg = config.custom.customDirs;
  inherit (lib) mkDefault mkOption mkEnableOption mkMerge mkIf;
  inherit (lib.types) str null nullOr attrsOf;
in {
  options.custom.customDirs = {
    enable = mkEnableOption "Enable custom home directories" // { default = true; };
    documents = mkOption {
      type = nullOr str;
      default = "/home/${user}/Storage/Media/Documents";
      example = "/home/${user}/Storage/Media/Documents";
      description = "Location of the documents folder";
    };
    downloads = mkOption {
      type = nullOr str;
      default = "/home/${user}/Storage/Media/Downloads";
      example = "/home/${user}/Storage/Media/Downloads";
      description = "Location of the downloads folder";
    };
    videos = mkOption {
      type = nullOr str;
      default = "/home/${user}/Storage/Media/Videos";
      example = "/home/${user}/Storage/Media/Videos";
      description = "Location of the videos folder";
    };
    pictures = mkOption {
      type = nullOr str;
      default = "/home/${user}/Storage/Media/Pictures";
      example = "/home/${user}/Storage/Media/Pictures";
      description = "Location of the pictures folder";
    };
    desktop = mkOption {
      type = nullOr str;
      default = null;
      example = "/home/${user}/Desktop";
      description = "Location of the desktop folder";
    };
    music = mkOption {
      type = nullOr str;
      default = null;
      example = "/home/${user}/Storage/Media/Music";
      description = "Location of the music folder";
    };
    extraFolders = mkOption {
      type = attrsOf str;
      default = { XDG_PROJECTS_DIR = "/home/${user}/Projects"; };
      example = { XDG_PROJECTS_DIR = "/home/${user}/Projects"; };
      description = "Attribute set of extra folders";
    };
  };

  config = (mkIf cfg.enable { 
    xdg.userDirs = {
      enable = true;
      createDirectories = true;
      
      extraConfig = cfg.extraFolders;
      desktop = cfg.desktop;
      music = cfg.music;
      download = cfg.downloads;
      pictures = cfg.pictures;
      documents = cfg.documents;
      videos = cfg.videos;

      # Will never need these
      templates = null;
      publicShare = null;
    };
  });
}
