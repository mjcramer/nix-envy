{ config, pkgs, lib, ... }: {
 
  home.packages = with pkgs; [
    unzip
  ];

  home.file.".local/downloads/1Password.zip".source = builtins.fetchurl {
    url = "https://downloads.1password.com/mac/1Password.zip";
    sha256 = "03ismzz4i9drxdj0kvk4y2pm8d5k94301wx0i6a4q71bgfmj26xr";
  };

  home.activation.install1Password = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    if [ ! -d "$HOME/Applications/1Password Installer.app" ]; then
      ${pkgs.unzip}/bin/unzip .local/downloads/1Password.zip -d $HOME/Applications
    else
      echo "1Password already installed!"
    fi
  '';
}
