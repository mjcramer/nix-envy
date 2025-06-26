{ pkgs, home-manager, vars, ... }: 
let 
  username = vars.username;
in {
  users = {
    users."${username}" = {
      isNormalUser = true;
      isSystemUser = false;
      home = "/Users/${username}";
      description = "User account for ${username}";
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
