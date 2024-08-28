alias b := build
alias s := switch

build HOST:
    sudo nixos-rebuild boot --flake .#{{HOST}}

switch HOST:
    sudo nixos-rebuild switch --flake .#{{HOST}}

tryswitch HOST:
    nixos-rebuild switch --flake .#{{HOST}} || true
    sudo nixos-rebuild switch --flake .#{{HOST}}
