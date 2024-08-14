default:
  just --list

# Update the lockfile of this configuration flake
update:
  nix flake update

# Format the source files of this configuration flake
fmt:
  nix fmt

# Check the source files of this configuration flake for error-free evaluation
check:
  nix flake check
  statix check

# Apply this configuration flake to the current NixOS system
switch-system: fmt check
  nixos-rebuild switch --use-remote-sudo --flake .#wsl-nixos

# Apply this configuration flake to your user
switch-home: fmt check
  home-manager switch --flake .#lukas@wsl-nixos

# Opens the sops secret file in the default console editor
edit-secrets:
  nix-shell -p sops --run "sops secrets/secrets.yaml"
