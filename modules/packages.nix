{ inputs, pkgs, ... }: 
let
  applications = with pkgs; [
    firefox
    zoom-us
  ]++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
    iterm2
  ];
in {

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
  ] ++ applications;

  system.activationScripts.postActivation.text = '' 
    echo "Copying nix applications:"
    applications=$(${pkgs.fd}/bin/fd --extension app --type directory --maxdepth 2 --follow . "$(realpath "/Applications/Nix Apps/")")
    for application in $applications; do
      app=$(basename "$application")
      if [ ! -d "/Applications/$app" ]; then
        echo "  Copying $app to /Applications..."
        cp -R "$application" /Applications
      else 
        echo "  Application $app is already present."
      fi
    done
  '';
}

    # echo "Copying Nix-installed .app bundles to /Applications/NixApps"
    # fd "/Applications/Nix Apps/*.app"
    #   pkgs.lib.concatStringsSep " " (map (pkg: "${pkg}/Applications") guiApps)
    # } -name '*.app' -exec cp -R {} /Applications/NixApps/ \;

# "Slack" "https://downloads.slack-edge.com/releases/macos/4.36.140/prod/universal/Slack-4.36.140-macOS.dmg"
# "Zoom" "https://zoom.us/client/5.17.11.31580/zoomusInstallerFull.pkg"
# "Spotify" "https://download.scdn.co/SpotifyInstaller.zip"
