# nix-envy

This project subsumes the [envy](https://github.com/mjcramer/envy) respository, which is where I used to keep my environment configuration, scripts and other minutia that I carry around from machine to machine. I am endeavoring to turn it into a declarative workstation configuration by which I can quickly (re)provision any of my machines. Its functions include:

 - Installing all the common programs and utilities that I need for typical operation
 - Configure my shell and set up my prompts 
 - Install my custom scripts and templates

# Initial Installation and Set-up 

- Install [[https://nixos.org/download.html#nix-install-macos][Nix, multi-user installation]].
  ```shell
  sh <(curl -L https://nixos.org/nix/install)
  ```
  For maximal pain management, I'm going with the official installer. I tried the [Determinate Systems Installer](https://determinate.systems/nix-installer/) but it did not play nicely with nix-darwin.

- Build the [nix-darwin](https://github.com/LnL7/nix-darwin) flake in this repository, using one of the following commands.
  ```shell
  nix --extra-experimental-features 'nix-command flakes' run nix-darwin -- switch --refresh --flake github:mjcramer/nix-envy
  ```
  Or, if you have the git repository checked out locally,
  ```shell
  nix --extra-experimental-features 'nix-command flakes' run nix-darwin -- switch --flake ./nix-envy
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
