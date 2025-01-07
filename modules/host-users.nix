{ pkgs, home-manager, ... }:

let
  hostname = "jozibean";
  username = "cramer";
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
}
