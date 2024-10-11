{ lib, config, pkgs, ... }: with lib;
let
  cli_programs = with pkgs; [
    pv
    tree
    yt-dlp
    ffmpeg
    zip
    unzip
    epubcheck
  ];

  gui_programs = with pkgs; [
    gsmartcontrol
  ];
in
{
  options.custom.programs.utility.common.all = mkEnableOption "Common utility programs";
  options.custom.programs.utility.common.cli = mkEnableOption "Common utility programs (CLI Only)";
  options.custom.programs.utility.common.gui = mkEnableOption "Common utility programs (GUI Only)";

  config = {
    environment.systemPackages =  optionals (config.custom.programs.utility.cli or config.custom.programs.utility.all) cli_programs
                               ++ optionals (config.custom.programs.utility.gui or config.custom.programs.utility.all) gui_programs;
  };
}
