{ config, pkgs, lib, ... }: {
 
  home.packages = with pkgs; [
    unzip
  ];

  home.file.".local/downloads/1Password.zip".source = builtins.fetchurl {
    url = "https://downloads.1password.com/mac/1Password.zip";
    sha256 = "1rzblb6ii49xpgp5hgafbqk1fjaly167lh2mbf0nrmdq9wa2w4pp";
  };

  home.activation.install1Password = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    if [ ! -d "$HOME/Applications/1Password Installer.app" ]; then
      ${pkgs.unzip}/bin/unzip .local/downloads/1Password.zip -d $HOME/Applications
    else
      echo "1Password already installed!"
    fi
  '';
}
