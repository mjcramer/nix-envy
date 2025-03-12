{ pkgs, ... }:

let
  scriptsDir = ./scripts;

  # Read the directory containing bash shell scripts and get filenames as a list
  # allFileNames = builtins.attrNames (builtins.readDir scriptsDir);

  # Filter the list to only include files ending in .sh using a regex match
  # shFileNames = builtins.filter
  #   (name: builtins.match ".*\\.sh$" name != null)
  #   allFileNames;
   
  # generatedScripts = builtins.map (
  # ) shFileNames;
  
  mkShScript = name:
    let
      # Remove the ".sh" extension from the file name.
      baseName = builtins.substring 0 (builtins.stringLength name - 3) name;
      # Read the content of the file.
      content = builtins.readFile (toString scriptsDir + "/" + name);
    in 
      # Create an executable script using pkgs.writeScript.
      pkgs.writeShellScriptBin baseName content;
    
  # _ = builtins.trace "generated scripts" (toString generatedScripts);
 
in {
  home.packages = [
    (pkgs.writeShellScriptBin "my-hello" ''
      echo "Hello there!"
    '')
    (mkShScript "git-shove.sh")
  ];
  # home.packages = builtins.map (name:
  #   let
  #     # Remove the ".sh" extension from the file name.
  #     baseName = builtins.substring 0 (builtins.stringLength name - 3) name;
  #     # Read the content of the file.
  #     content = builtins.readFile (toString scriptsDir + "/" + name);
  #   in
  #     # Create an executable script using pkgs.writeScript.
  #     pkgs.writeScript baseName ''
  #       ${content}
  #     ''
  # ) shFileNames;
}
