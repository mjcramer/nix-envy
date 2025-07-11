{ pkgs, lib, ... }: {

  system.activationScripts.installHomebrew.text = ''
    if [ ! -x /opt/homebrew/bin/brew ]; then
      echo "Installing Homebrew..."
      NONINTERACTIVE=1 /bin/bash -c "$(
        curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
      )"
      eval "$(/opt/homebrew/bin/brew shellenv)"
    else
      echo "Homebrew already installed."
    fi
  '';

  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      cleanup = "zap"; # fully remove old versions
    };

    global = {
      brewfile = true;  # allows defining casks/taps/brews in Nix
      autoUpdate = true;
    };

    casks = [
      "1password"
      "firefox"
      "libreoffice"
      "zoom"
      "iterm2"
      "spotify"
      "sizeup"
      "beyond-compare"
      "intellij-idea"
      "visual-studio-code"
    ];

    brews = [ 
    ];

    taps = [
    ];
  };
}
