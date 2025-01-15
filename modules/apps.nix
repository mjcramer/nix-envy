{ inputs, pkgs, ... }: {

  environment.extraInit = ''
    export PATH=$HOME/bin:$PATH
  '';

  # install packages from nix's official package repository.
  environment.systemPackages = with pkgs; [
    awscli
    bash
    curl
    fd
    fish
    fzf
    git
    gnugrep
    grc
    htop
    iftop
    # jenv
    jq # json query
    lsd # much better ls
    nil # nix language server
    openssh
    python3
    scala
    sbt
    # terraform
    tmux
    tree
    vim_configurable
    watch
    wget
    zsh
  ];

  # To make this work, homebrew need to be installed manually, see
  # https://brew.sh The apps installed by homebrew are not managed by nix, and
  # not reproducible!  But on macOS, homebrew has a much larger selection of
  # apps than nixpkgs, especially for GUI apps!

  # work mac comes with brew
  # homebrew = {
  #   enable = true;

  #   onActivation = {
  #     autoUpdate = true;
  #     # 'zap': uninstalls all formulae(and related files) not listed here.
  #     cleanup = "zap";
  #   };

  #   taps = [ "CtrlSpice/homebrew-otel-desktop-viewer" ];

  #   # brew install
  #   brews = [ "otel-desktop-viewer" ];

  #   # brew install --cask
  #   # these need to be updated manually
  #   casks = [ "swiftbar" "spotify" "zoom" "intellij-idea" ];

  #   # mac app store
  #   # click
  #   masApps = {
  #     amphetamine = 937984704;
  #     kindle = 302584613;
  #     tailscale = 1475387142;

  #     # useful for debugging macos key codes
  #     #key-codes = 414568915;
  #   };
  # };
}


    # "iTerm" "https://iterm2.com/downloads/stable/iTerm2-3_4_23.zip"
    # "Slack" "https://downloads.slack-edge.com/releases/macos/4.36.140/prod/universal/Slack-4.36.140-macOS.dmg"
    # "1Password" "https://downloads.1password.com/mac/1Password.zip"
    # "Zoom" "https://zoom.us/client/5.17.11.31580/zoomusInstallerFull.pkg"
    # "Spotify" "https://download.scdn.co/SpotifyInstaller.zip"
    # # "Intellij Idea" "https://www.jetbrains.com/idea/download/download-thanks.html?platform=mac"
    # # "Firefox" "https://download.mozilla.org/?product=firefox-latest-ssl&os=osx&lang=en-US"
    # "SizeUp" "https://www.irradiatedsoftware.com/downloads/?file=SizeUp.zip"
    # "VS Code" "https://code.visualstudio.com/sha/download?build=stable&os=darwin-universal"
