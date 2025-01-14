{
  enable = true;
  userName = "Michael Cramer";
  userEmail = "mjcramer@gmail.com";
  aliases = {
    unstage = "reset HEAD";
    undo-commit = "reset --soft HEAD^";
    poh = "push origin HEAD";
    puh = "pull origin HEAD";
    set-upstream = "!git branch --set-upstream-to=origin/`git symbolic-ref --short HEAD`";
  };

  extraConfig = {
    core = {
      editor = "vim";
      autocrlf = "input";
      excludesfile = "/Users/cramer/.gitignore_global";
    };
    color = { 
      ui = true;
    };
    init = {
      defaultBranch = "main";
    };
    push = { 
      autoSetupRemote = true; 
      default = "current";
    };
    pull = { 
      rebase = true;
    };
    branch = { 
      autosetuprebase = "always";
    };
    diff = { 
      tool = "bcomp";
    };
    difftool = { 
      prompt = false;
      bcomp = {
        trustExitCode = true;
        cmd = "/usr/local/bin/bcomp $LOCAL $REMOTE";
      };
    };
    merge = {
      tool = "bcomp";
    };
    mergetool = {
      prompt = false;
      bcomp = {
        trustExitCode = true;
        cmd = "/usr/local/bin/bcomp $LOCAL $REMOTE $BASE $MERGED";
      };
    };
    filter = {
      lfs = {
        clean = "git-lfs clean -- %f";
        smudge = "git-lfs smudge -- %f";
        process = "git-lfs filter-process";
        required = true;
      };
    };  
    url = {
      "ssh://git@github.com/" = {
        insteadOf = "https://github.com/";
      };
    };
  };
}
