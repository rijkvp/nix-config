{ ... }:
{
  programs.git = {
    enable = true;
    delta = {
      enable = true; # syntax highlighting
      options = {
        syntax-theme = "base16";
      };
    };
    userName = "Rijk van Putten";
    userEmail = "rijk@rijkvp.nl";
    signing = {
      key = "~/.ssh/id_ed25519";
      signByDefault = true;
    };
    extraConfig = {
      gpg.format = "ssh";
      pull.rebase = "true";
      init.defaultBranch = "main";
      rebase.autoStash = "true";
    };
    aliases = {
      s = "status";
      st = "status";
      ch = "checkout";
      d = "diff";
      df = "diff";
      a = "add";
      c = "commit";
      p = "push";
      pl = "pull";
      rt = "restore";
      rs = "reset";
      m = "merge";
    };
  };
}
