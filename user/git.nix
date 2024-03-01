{...}:
{
  programs.git = {
    enable = true;
    ignores = [
      "*~"
      "*.swp"
      "notes"
    ];
  };
}
