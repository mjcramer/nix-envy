{ config, pkgs, lib, ... }: {

  home.packages = with pkgs; [
    unzip
  ];

  home.file.".local/downloads/SizeUp.zip".source = builtins.fetchurl {
    url = "https://www.irradiatedsoftware.com/downloads/SizeUp.zip";
    sha256 = "1kq2iavpcxiskr2wqrbp9n3z608gg7pmyrp0xikwh3bwc8a9abjz";
  };

  home.activation.installSizeUp = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    if [ ! -d "/Applications/SizeUp.app" ]; then
      ${pkgs.unzip}/bin/unzip .local/downloads/SizeUp.zip -d /Applications
    else
      echo "SizeUp already installed!"
    fi
  '';
}
