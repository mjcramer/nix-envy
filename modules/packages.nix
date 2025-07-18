{ inputs, pkgs, ... }: {

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = _: true;

  # The following are standard tools and commands needed for basic operation. It includes some complex but generic
  # tooling that may be used for development but generally aren't specific requirements for it. Not that development
  # tooling and shell integrations are not kept here, this are managed by nix home-manager
  environment.systemPackages = with pkgs; [
    bash
    curl
    fd # simpler intuitive alternative to find
    fzf # fuzzy finder
    git 
    gnugrep
    grc # generic text colorize
    htop
    iftop
    nmap # networking tool
    openssh
    python3
    tree
    watch
    wget
    zsh
  ];
}
