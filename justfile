alias b := build
alias s := switch

build HOST:
    sudo nixos-rebuild boot --flake .#{{HOST}}

switch HOST:
    sudo nixos-rebuild switch --flake .#{{HOST}}
