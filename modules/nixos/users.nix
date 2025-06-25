{ pkgs, home-manager, vars, ... }: 
let 
  username = vars.username;
in {
   users.users."${username}" = {
    isNornalUser = true;
    isSystemUser = false;
    home = "/Users/${username}";
    description = username;
    shell = pkgs.fish;
  };

   nix.settings.trusted-users = [ username ];
}
