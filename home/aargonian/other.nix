{ pkgs, ... }:
let
  todoWrapper = pkgs.writeShellScriptBin "todo" ''
    #!${pkgs.zsh}/bin/zsh
    todoist quick "$*"
  '';
in
{
  home.packages = with pkgs; [
    todoist
    todoWrapper
  ];
}
