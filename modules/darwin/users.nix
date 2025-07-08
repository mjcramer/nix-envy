{ pkgs, home-manager, vars, ... }: 
let 
  username = vars.username;
  homeDirectory = vars.homeDirectory;
in {
   users.users."${username}" = {
    home = homeDirectory;
    description = "User account for ${username} in ${homeDirectory}";
    shell = pkgs.fish;
  };

   nix.settings.trusted-users = [ username ];

   # activation.setWallpaper = lib.hm.dag.entryAfter ["linkGeneration"] (builtins.readFile ./helpers/set-wallpapers.sh);

}
