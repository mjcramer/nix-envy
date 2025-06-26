{ pkgs, home-manager, vars, ... }: 
let 
  username = vars.username;
in {
   users = {
    users."${username}" = {
      isNornalUser = true;
      isSystemUser = false;
      home = "/Users/${username}";
      description = "User account for ${username}";
      group = username;
      shell = pkgs.fish;
    };
    groups."${username}" = {};
  };
  nix.settings.trusted-users = [ username ];
}
