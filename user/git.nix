{ pkgs, ...}:
{
  home.packages = with pkgs; [
    libsecret
  ];

  programs.git = {
    enable = true;
    userName = "Aaron Gorodetzky";
    userEmail = "aaron@nytework.com";
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
