{ pkgs, home-manager, ... }:

let
  hostname = "oxford-corp-cramer";
  username = "mjcramer";
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
