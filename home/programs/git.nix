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
      pull.rebase = true;
      push.autoSetupRemote = true;
      init.defaultBranch = "main";
      rebase = {
        autoSquash = true;
        autoStash = true;
        updateRefs = true;
      };
      credential.helper = "store"; # unsafe, but convenient

      # https://blog.gitbutler.com/how-git-core-devs-configure-git/
      column.ui = "auto";
      branch.sort = "-committerdate";
      tag.sort = "-taggerdate";
      diff = {
        algorithm = "histogram";
        colorMoved = "plain";
        mnemonicPrefix = true;
        renames = true;
      };
      fetch = {
        prune = true;
        pruneTags = true;
        all = true;
      };

      help.autocorrect = "prompt";
      commit.verbose = true;
      rerere = {
        enabled = true;
        autoupdate = true;
      };

      merge.conflictStyle = "zdiff3"; # also shows the original version
    };
    aliases = {
      a = "add";
      c = "commit";
      ch = "checkout";
      d = "diff";
      df = "diff";
      m = "merge";
      p = "push";
      pl = "pull";
      rs = "reset";
      rt = "restore";
      s = "status";
      st = "status";
      sw = "switch";
    };
  };
}
