{ pkgs, home-manager, vars, ... }: 
let 
  username = vars.username;
  homeDirectory = vars.homeDirectory;
in {
  users = {
    users."${username}" = {
      isNormalUser = true;
      isSystemUser = false;
      home = homeDirectory;
      description = "User account for ${username} in ${homeDirectory}";
      group = username;
      extraGroups = [ 
        "wheel" 
        "networkmanager" 
        "docker" 
      ];
      shell = pkgs.fish;
    };
    groups."${username}" = {};
  };
  security.sudo.wheelNeedsPassword = false;
  nix.settings.trusted-users = [ username ];
}
