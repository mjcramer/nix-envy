{ config, pkgs, lib, ... }: 
let 
  version = "5.0.6.30713";
  sha256 = "0fzcfjb0n3xphbcy8rfwy3yv1j6sh57d2m15f1qcg1xnra2s9l4y";
in {
  home.packages = with pkgs; [
    unzip
  ];

  # TODO: Need to check for darwin here
  home.file.".local/downloads/BeyondCompare.zip".source = builtins.fetchurl {
    url = "https://www.scootersoftware.com/files/BCompareOSX-${version}.zip";
    inherit sha256;
  };

  home.activation.installBeyondCompare = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    if [ ! -d "/Applications/Beyond Compare.app" ]; then
      ${pkgs.unzip}/bin/unzip .local/downloads/BeyondCompare.zip -d /Applications
    else
      echo "Beyond Compare already installed!"
    fi
  '';
}
