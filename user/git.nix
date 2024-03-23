{ pkgs, ...}:
{
  home.packages = with pkgs; [
    libsecret
  ];

  programs.git = {
    enable = true;
    ignores = [
      "*~"
      "*.swp"
      "notes"
    ];
    extraConfig.credential.helper = "${
        pkgs.git.override { withLibsecret = true; }
    }/bin/git-credential-libsecret";
  };
}
