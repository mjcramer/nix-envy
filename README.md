# nix-envy

This project subsumes the [envy](https://github.com/mjcramer/envy) respository, which is where I used to keep my environment configuration, scripts and other minutia that I carry around from machine to machine. Some of its features include:

 - common programs and utilities
 - shell configuration

## first time setup

- Install [[https://nixos.org/download.html#nix-install-macos][Nix, multi-user installation]].
- Borrow nescessary parts off of the [[https://github.com/ryan4yin/nix-darwin-kickstarter/tree/main/minimal][nix-darwin-kickstarter/minimal]], and put it in =~/.config/nix-darwin= (this repo).
- [[https://github.com/LnL7/nix-darwin/blob/master/README.md#step-2-installing-nix-darwin][Install nix-darwin]], using nix it self, and nix flakes

```shell
nix --extra-experimental-features 'nix-command flakes' \
  run nix-darwin -- switch --flake nix-darwin
```

** build the system and switch to it

```shell
darwin-rebuild switch --flake ~/.config/nix-darwin
```

(needs root)

** repo contents




** updating

you can bump all inputs/dependencies, which updates the =flake.lock=, with

```shell
nix flake update
```

you can bump a single input, e.g. nixpkgs-firefox-darwin, with

```shell
nix flake lock --update-input nixpkgs-firefox-darwin
```

remember to =darwin-rebuild switch= afterwards

** clean up leftover applications

when you recreate your system for the millionth time, you might end up with multiple applications that no longer represent what your config means should be the current one, meaning commands like =open -a <app name>= and "Open With" might open apps you no longer mean to have installed

you can see all these generations of systems with

```shell
darwin-rebuild --list-generations
```

you can find out what is keeping built derivations alive by looking up their path in the nix store

```shell
nix-store --query --roots /nix/store/
```

you can clean up leftover generations older than 7 days with

```shell
nix-collect-garbage --delete-older-than 7d
sudo nix-collect-garbage --delete-older-than 7d
```

you can clean up all leftover generations with

```shell
nix-collect-garbage -d
sudo nix-collect-garbage -d
```



# Install nix

Default Nix install...
```shell
curl -L https://nixos.org/nix/install | sh
```

Or you can use the Determinate Systems installer...
```shell
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --determinate
```

 ## Configure command and flakes
 
Add the following to `/etc/nix/nix.conf`
```
experimental-features = nix-command flakes
```

Restart the nix daemon
```shell
sudo launchctl stop org.nixos.nix-daemon
sudo launchctl start org.nixos.nix-daemon
```

# Install nix-darwin

```shell
nix build github:LnL7/nix-darwin
./result/bin/darwin-installer

nix-channel --add https://github.com/LnL7/nix-darwin/archive/master.tar.gz darwin
nix-channel --update

```
# Repair nix

```shell
rm -rf ~/.cache/nix
sudo nix-collect-garbage -d
sudo nix-store --verify --check-contents





# Uninstall nix

# Remove nix-profile start lines from these files:

```shell
sudo vi /etc/zshrc
sudo vi /etc/bashrc
sudo vi /etc/bash.bashrc
sudo rm /etc/*.backup-before-nix

# Unload daemon
sudo launchctl unload /Library/LaunchDaemons/org.nixos.nix-daemon.plist
sudo rm /Library/LaunchDaemons/org.nixos.nix-daemon.plist
sudo launchctl unload /Library/LaunchDaemons/org.nixos.darwin-store.plist
sudo rm /Library/LaunchDaemons/org.nixos.darwin-store.plist

# Remove groups
sudo dscl . -delete /Groups/nixbld
for u in $(sudo dscl . -list /Users | grep _nixbld); do sudo dscl . -delete /Users/$u; done

# Remove nix mount
sudo vifs

sudo rm /etc/synthetic.conf*
sudo rm -rf /etc/nix /var/root/.nix-profile /var/root/.nix-defexpr /var/root/.nix-channels ~/.nix-profile ~/.nix-defexpr ~/.nix-channels
sudo diskutil apfs deleteVolume /nix
```
