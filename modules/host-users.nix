{ pkgs, vars, ... }:

let
  hostname = vars.hostname;
  username = vars.username;
in {
  # Set the hostname
  networking.hostName = hostname;
  networking.computerName = hostname;
  system.defaults.smb.NetBIOSName = hostname;

  users.users."${username}" = {
    home = "/Users/${username}";
    description = username;
    shell = pkgs.fish;
  };

   nix.settings.trusted-users = [ username ];
}
