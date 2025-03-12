{ pkgs, vars, ... }:

let
  hostname = vars.hostname;
in {
  # Set the hostname
  networking.hostName = hostname;
  networking.computerName = hostname;
  system.defaults.smb.NetBIOSName = hostname;
}
