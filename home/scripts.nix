{ pkgs, ... }:

let
  scriptsDir = ./scripts;

  # scripts = pkgs.buildEnv {
  #   name = "scripts";
  #   paths = lib.concatMap (scriptFile: [
  #     (pkgs.writeShellScriptBin (lib.strings.removeSuffix ".sh" (lib.strings.baseName scriptFile)) (builtins.readFile "${scriptsDir}/${scriptFile}"))
  #   ]) (builtins.attrValues (builtins.readDir scriptsDir));
  # };

  # Read the directory containing bash shell scripts and get filenames as a list
  allFileNames = builtins.attrNames builtins.readDir scriptsDir;

  contents = builtins.readFile (toString scriptsDir + "/git-shove.sh");
  lines = builtins.split "\n" contents;
  filteredLines = builtins.filter (line: builtins.typeOf line == "string") lines;
  linesWithoutFirst = builtins.tail filteredLines;
  newContents = builtins.concatStringsSep "\n" filteredLines;


  # Filter the list to only include files ending in .sh using a regex match
  shFileNames = builtins.filter
    (name: builtins.match ".*\\.sh$" name != null)
    allFileNames;


   
  # For each .sh file, generate a script with the same content but with the ".sh" removed from its name.
  # generatedScripts = builtins.mapAttrs (name: _:
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
 
in {
  home.packages = [
    (pkgs.writeShellScriptBin "my-hello" ''
      echo "Hello there!"
    '')
    (pkgs.writeShellScriptBin "git-shove" newContents)
  ];
}
