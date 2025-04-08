{ config, pkgs, lib, ... }: {
 
  programs._1password = {
    enable = true;
    enableCli = true;
  };
}
