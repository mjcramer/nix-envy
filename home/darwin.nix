{ config, pkgs, lib, vars, ... }:

let
  # Pass in username and hostname
  username = vars.username;
  homeDirectory = vars.homeDirectory;
  hostname = vars.hostname;

in {
}
