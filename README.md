# nix-envy

This project subsumes the [envy](https://github.com/mjcramer/envy) respository, which is where I used to keep my environment configuration, scripts and other minutia that I carry around from machine to machine. Some of its features include:
 - common programs and utilities
 - fish shell configuration

## first time setup

- Install [[https://nixos.org/download.html#nix-install-macos][Nix, multi-user installation]].
- Borrow nescessary parts off of the [[https://github.com/ryan4yin/nix-darwin-kickstarter/tree/main/minimal][nix-darwin-kickstarter/minimal]], and put it in =~/.config/nix-darwin= (this repo).
- [[https://github.com/LnL7/nix-darwin/blob/master/README.md#step-2-installing-nix-darwin][Install nix-darwin]], using nix it self, and nix flakes

```shell
nix --extra-experimental-features 'nix-command flakes' \
  run nix-darwin -- switch --flake nix-darwin
```

** build the system and switch to it

#+begin_src sh
darwin-rebuild switch --flake ~/.config/nix-darwin
#+end_src

(needs root)

** repo contents

- [[./flake.nix][flake.nix]]
  - main entrypoint
  - systems configuration: only one for a single mac
  - dependency setup: inputs
- [[./flake.lock][flake.lock]]
  - pinned versions of all dependencies
- [[./modules/][modules/]]
  - [[./modules/apps.nix][apps.nix]]: system and homebrew packages
  - [[./modules/host-users.nix][host-users.nix]]: machine and user setup
  - [[./modules/nix-core.nix][nix-core.nix]]: configuration of nix itself on the machine
  - [[./modules/system.nix][system.nix]]: mac specific settings; dock, keyboard, finder++
- [[./home/][home/]]
  - [[https://nixos.wiki/wiki/Home_Manager][home manager modules]]: user specific package configuration
  - most of these modules are pulled in from [[https://github.com/torgeir/nix-home-manager][torgeir/nix-home-manager]]

** a few nice things

pkgs, overlays, overrides++

- [[./pkgs/patch-nerd-fonts/default.nix][patch-nerd-fonts]]: a derivation to patch a font with nerd font symbols
- [[https://github.com/torgeir/nix-darwin/blob/095913bf96cfcf29c42992ac7d85776097f015b3/home/firefox-extensions.nix#L3C20-L15][firefox-extensions.nix]]: borrow [[https://github.com/nix-community/nur-combined/blob/master/repos/rycee/pkgs/firefox-addons/default.nix#L5-L23][rycee's code]] from [[https://nur.nix-community.org/][NUR]] (Nix User Repository) for [[https://github.com/torgeir/nix-darwin/blob/095913bf96cfcf29c42992ac7d85776097f015b3/home/firefox-extensions.nix#L18-L78][installing firefox extensions]]
- [[https://github.com/torgeir/nix-home-manager/blob/acd92c3c200328db16168e0f50173859c5aada5f/modules/emacs.nix][emacs with a few patches]]: overridden emacs29 package to compile it with selected patches, inspired by [[https://github.com/noctuid/dotfiles/blob/30f615d0a8aed54cb21c9a55fa9c50e5a6298e80/nix/overlays/emacs.nix#L26][noctuid's config]], e.g. to work with the [[https://github.com/koekeishiya/yabai][yabai tiling vm]]

** input flakes

aka dependencies

- [[https://github.com/nixos/nixpkgs/tree/nixpkgs-23.11-darwin][nixpkgs-darwin]]: nixpkgs for macos
- [[https://github.com/LnL7/nix-darwin/][nix-darwin]]: nix support for configuring macs
- [[https://github.com/nix-community/home-manager/tree/release-23.11][home-manager]]: nix module for user specific package configuration

** overlays

aka nix package extensions or modifications

- [[https://github.com/bandithedoge/nixpkgs-firefox-darwin/][nixpkgs-firefox-darwin]]: an overlay to provide firefox built for darwin

** updating

you can bump all inputs/dependencies, which updates the =flake.lock=, with

#+begin_src nix
nix flake update
#+end_src

you can bump a single input, e.g. nixpkgs-firefox-darwin, with

#+begin_src nix
nix flake lock --update-input nixpkgs-firefox-darwin
#+end_src

remember to =darwin-rebuild switch= afterwards

** clean up leftover applications

when you recreate your system for the millionth time, you might end up with multiple applications that no longer represent what your config means should be the current one, meaning commands like =open -a <app name>= and "Open With" might open apps you no longer mean to have installed

you can see all these generations of systems with

#+begin_src sh
darwin-rebuild --list-generations
#+end_src

you can find out what is keeping built derivations alive by looking up their path in the nix store

#+begin_src sh :noeval
nix-store --query --roots /nix/store/...
#+end_src

you can clean up leftover generations older than 7 days with

#+begin_src sh :noeval
nix-collect-garbage --delete-older-than 7d
sudo nix-collect-garbage --delete-older-than 7d
#+end_src

you can clean up all leftover generations with

#+begin_src sh :noeval
nix-collect-garbage -d
sudo nix-collect-garbage -d
#+end_src
