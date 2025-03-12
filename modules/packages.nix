{ inputs, pkgs, ... }: {

  # The following are standard tools and commands needed for basic operation. It includes some complex but generic
  # tooling that may be used for development but generally aren't specific requirements for it. Not that development
  # tooling and shell integrations are not kept here, this are managed by nix home-manager
  environment.systemPackages = with pkgs; [
    bash
    curl
    fd # simpler intuitive alternative to find
    fzf # fuzzy finder
    git 
    gnugrep
    grc # generic text colorize
    htop
    iftop
    jq # json query
    lsd # much better ls
    neovim # modern vim 
    nil # nix language server
    nmap # networking tool
    openssh
    python3
    tree
    watch
    wget
    zsh
    (vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions; [
        bbenoist.nix
        ms-python.python
        ms-azuretools.vscode-docker
        ms-vscode-remote.remote-ssh
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "remote-ssh-edit";
          publisher = "ms-vscode-remote";
          version = "0.47.2";
          sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
        }
      ];
    })
  ];

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
