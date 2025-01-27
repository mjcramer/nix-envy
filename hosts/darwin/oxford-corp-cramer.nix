{ inputs, pkgs, ... }: {

  home.packages = with pkgs; [
    kafka
  ];

}