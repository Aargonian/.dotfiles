{ lib, config, pkgs, pkgs-unstable, ... }: with lib;
#let
#  # Define your programs with their categories and requirements
#  programs = {
#    ncspot = {
#      package = pkgs.ncspot;
#      category = "cli";
#      requires = [];
#    };
#    spotify = {
#      package = pkgs.spotify;
#      category = "gui";
#      requires = ["custom.system.display.enable"];
#    };
#    vlc = {
#      package = pkgs.vlc;
#      category = "gui";
#      requires = ["custom.system.display.enable"];
#    };
#    pavucontrol = {
#      package = pkgs.pavucontrol;
#      category = "util";
#      requires = ["custom.system.display.enable"];
#    };
#    pa_applet = {
#      package = pkgs.pa-applet;
#      category = "util";
#      requires = ["custom.system.display.enable"];
#    };
#  };
#
#  # Generate options for individual programs
#  programOptions = lib.genAttrs (builtins.attrNames programs) (name: {
#    enable = lib.mkEnableOption "Enable ${name}";
##  });
#
#in
#with lib;
#{
#  options.custom.programs = (programOptions // {
#      audio = {
#        all = mkEnableOption "All Audio Programs";
#        cli = mkEnableOption "CLI Audio Applications";
#        gui = mkEnableOption "GUI Audio Applications";
#        util = mkEnableOption "Audio Utility Applications";
#      };
#    });
#
#  config = let
#    audioAll = config.custom.programs.audio.all or false;
#    audioCli = config.custom.programs.audio.cli or audioAll;
#    audioGui = config.custom.programs.audio.gui or audioAll;
#    audioUtil = config.custom.programs.audio.util or audioAll;
#
#    # Helper function to get the enable value for a program
#    getProgramEnable = name: let
#      category = programs.${name}.category;
#      groupEnable = if category == "cli" then audioCli else if category == "gui" then audioGui else audioUtil;
#      individualEnable = config.custom.programs.${name}.enable or mkDefault groupEnable;
#    in individualEnable;
#
#    # Build the list of enabled programs
#    enabledPrograms = builtins.concatLists (map (name:
#      if getProgramEnable name then [ programs.${name}.package ] else []
#    ) (builtins.attrNames programs));
#
#    # Build assertions for required options
#    requiredOptionAssertions = concatLists (map (name:
#      let
#        programEnabled = getProgramEnable name;
#        programRequires = programs.${name}.requires;
#        unsatisfiedRequires = filter (reqOptionPath:
#          let
#            optionValue = builtins.getAttrFromPath (lib.splitString "." reqOptionPath) config;
#          in
#            optionValue != true
#        ) programRequires;
#      in
#        if programEnabled && (unsatisfiedRequires != []) then
#          [ {
#              assertion = false;
#              message = "Program '${name}' requires the following options to be enabled: ${builtins.concatStringsSep ", " unsatisfiedRequires}";
#            } ]
#        else
#          []
#    ) (builtins.attrNames programs));
#
#  in {
#    # Include assertions to ensure required options are enabled
#    assertions = requiredOptionAssertions ++ [
#      {
#        assertion = config.custom.system.audio.enable || !(any (name: getProgramEnable name) (builtins.attrNames programs));
#        message = "Audio programs are enabled, but 'custom.system.audio.enable' is not set to true.";
#      }
#    ];
#
#    # Set system packages to include the enabled programs
#    environment.systemPackages = enabledPrograms;
#  };
#}
#
{
  options.custom.programs = {
      audio = {
        all = mkEnableOption "All Audio Programs";
        cli = mkEnableOption "CLI Audio Applications";
        gui = mkEnableOption "GUI Audio Applications";
        util = mkEnableOption "Audio Utility Applications";
      };
    };

  config = mkIf config.custom.programs.audio.all {
    environment.systemPackages = with pkgs; [
      pa_applet
      pavucontrol
      spotify
      vlc
    ] ++ [
      pkgs-unstable.ncspot
    ];
  };
}
