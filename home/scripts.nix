{ pkgs, ... }:

let
  scriptsDir = ./scripts;

  # Read the directory containing bash shell scripts and get filenames as a list
  allFileNames = builtins.attrNames (builtins.readDir scriptsDir);

  # Filter the list to only include files ending in .sh using a regex match
  scriptFileNames = builtins.filter
    (name: builtins.match ".*\\.(sh)$" name != null)
    allFileNames;
   
  mkScript = name:
    let
      # Remove the ".sh" extension from the file name.
      baseName = builtins.substring 0 (builtins.stringLength name - 3) name;
      # Read the content of the file.
      content = builtins.readFile (toString scriptsDir + "/" + name);
    in 
      # Create an executable script using pkgs.writeScript.
      pkgs.writeScriptBin baseName content;

in {
  home.packages = builtins.map mkScript scriptFileNames;
}
