{
  programs.git = {
    enable = true;
    userName = "jthulhu";
    userEmail = "adrien.lc.mathieu@gmail.com";
    signing = {
      signByDefault = true;
      key = null;
    };
    aliases = {
      co = "checkout";
      st = "status";
      tree = "log --graph --format='format:%C(dim red)%h%Creset %s %C(brightblue)%d'";
      tr = "tree";
    };
    ignores = [
      # Emacs
      "*~"
      # Direnv
      ".direnv/"
      # Nix
      "result"
      # Python
      "__pycache__/"
      # Rust
      "target/"
    ];
    extraConfig = {
      init = {
        defaultBranch = "release";
      };
      push.autoSetupRemote = true;
    };
  };
}
