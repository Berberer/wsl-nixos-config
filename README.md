# NixOS Configuration for WSL

## Prerequisites
* Download a [Nerd Font](https://www.nerdfonts.com/font-downloads) and cofigure it in your terminal emulator.

## Get Started
Install the latest [NixOS WSL release](https://github.com/nix-community/NixOS-WSL).

Initial updates:
```bash
sudo nix-channel --add https://nixos.org/channels/nixos-24.05 nixos
sudo nix-channel --update
sudo nixos-rebuild switch
```

Clone this configuration:
```bash
nix-shell -p git --run "git clone https://github.com/Berberer/wsl-nixos-config /tmp/wsl-nixos-config"
```

Adjust to the cloned configuration. Afterwards, run the following command to apply the configuration:
```bash
nix-shell -p git --run "sudo nixos-rebuild switch --flake /tmp/wsl-nixos-config#wsl-nixos"
```

Shutdown and restart the WSL and enter it again.

Create the `age` key at the following location:
```bash
~/.config/sops/age/keys.txt
```

Run the following commands:
```bash
mv /tmp/wsl-nixos-config ~/wsl-nixos-config
cd ~/wsl-nixos-config
sudo nixos-rebuild switch --flake .#wsl-nixos
home-manager switch --flake .#lukas@wsl-nixos
```

## Additional Commands
Once the initial installation is done, most interactions can be done via `just` commands inside of `~/wsl-nixos-config`:
| Command              | Description                                                                 |
|----------------------|-----------------------------------------------------------------------------|
| `just update`        | Update the lockfile of this configuration flake                             |
| `just fmt`           | Format the source files of this configuration flake                         |
| `just check`         | Check the source files of this configuarion flake for error-free evaluation |
| `just switch-system` | Apply this configuration flake to the current NixOS system                  |
| `just switch-home`   | Apply this configuration flake to your user                                 |
| `just edit-secrets`  | Opens the sops secret file in the default console editor                    |
