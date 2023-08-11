{ ... }: {
  programs.git = {
    enable = true;
    userName = "rijkvp";
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
      d = "diff";
      df = "diff";
      a = "add";
      c = "commit";
      p = "push";
    };
  };
}

