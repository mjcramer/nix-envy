# nix-envy

This project subsumes the [envy](https://github.com/mjcramer/envy) repository, which is where I used to keep my 
environment configuration, scripts and other minutia that I carry around from machine to machine. I am endeavoring to 
turn it into a declarative workstation configuration by which I can quickly (re)provision any of my machines. Its 
functions include:

 - Installing all the common programs and utilities that I need for typical operation
 - Configure my shell and set up my prompts 
 - Install my custom scripts and templates

# Initial Installation and Set-up

## Install on MacOS

1. Install [[https://nixos.org/download.html#nix-install-macos][Nix, multi-user installation]].
   ```shell
   sh <(curl -L https://nixos.org/nix/install)
   ```

2. Build the [nix-darwin](https://github.com/LnL7/nix-darwin) flake in this repository, using one of the following commands.
   ```shell
   nix --extra-experimental-features 'nix-command flakes' run nix-darwin -- switch --refresh --flake github:mjcramer/nix-envy
   ```
   Or, if you have the git repository checked out locally,
   ```shell
   nix --extra-experimental-features 'nix-command flakes' run nix-darwin -- switch --flake ./nix-envy
   ```

3. Once you have successfully built, inside the new shell you can build with
   ```shell
   darwin-rebuild switch --flake ./nix-envy
   ```

## Install Nix on Ubuntu

1. Run the default Nix install...
   ```shell
   curl -L https://nixos.org/nix/install | sh
   ```

2. Source the following file or restart shell...
   ```shell
   . ~/.nix-profile/etc/profile.d/nix.sh
   ```

3. Create the config directory and enable flakes...
   ```shell
   mkdir -p ~/.config/nix
   echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
   ```

## Determinate Nix Installer

For maximal pain management, I'm going with the official installer. I tried the [Determinate Systems Installer,](https://determinate.systems/nix-installer/) 
but it did not play nicely with nix-darwin. Obviously, your mileage may vary. If you want you can use the Determinate Systems installer...
```shell
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --determinate
```

## Additional Commands

You can bump all inputs/dependencies, which updates the =flake.lock=, with
```shell
nix flake update
```

List the previous builds 
```shell
darwin-rebuild --list-generations
```

You can find out what is keeping built derivations alive by looking up their path in the nix store
```shell
nix-store --query --roots /nix/store/
```

You can clean up leftover generations older than 7 days with
```shell
nix-collect-garbage --delete-older-than 7d
sudo nix-collect-garbage --delete-older-than 7d
```

You can clean up all leftover generations with
```shell
nix-collect-garbage -d
sudo nix-collect-garbage -d
```

## Repair nix

```shell
rm -rf ~/.cache/nix
sudo nix-collect-garbage -d
sudo nix-store --verify --check-contents





## Uninstall nix

Remove nix-profile start lines from these files:
```shell
sudo vi /etc/zshrc
sudo vi /etc/bashrc
sudo vi /etc/bash.bashrc
sudo rm /etc/*.backup-before-nix
```

Unload daemon
```
sudo launchctl unload /Library/LaunchDaemons/org.nixos.nix-daemon.plist
sudo rm /Library/LaunchDaemons/org.nixos.nix-daemon.plist
sudo launchctl unload /Library/LaunchDaemons/org.nixos.darwin-store.plist
sudo rm /Library/LaunchDaemons/org.nixos.darwin-store.plist
```

Remove groups
```
sudo dscl . -delete /Groups/nixbld
for u in $(sudo dscl . -list /Users | grep _nixbld); do sudo dscl . -delete /Users/$u; done
```
Remove nix mount
```
sudo vifs

sudo rm /etc/synthetic.conf*
sudo rm -rf /etc/nix /var/root/.nix-profile /var/root/.nix-defexpr /var/root/.nix-channels ~/.nix-profile ~/.nix-defexpr ~/.nix-channels
sudo diskutil apfs deleteVolume /nix
```
