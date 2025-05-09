alias b := build
alias s := switch

build HOST:
    sudo nixos-rebuild boot --flake .#{{HOST}}

switch HOST:
    sudo nixos-rebuild switch --flake .#{{HOST}}

fast HOST:
    sudo nixos-rebuild switch --flake .#{{HOST}} --fast

tryswitch HOST:
    sudo -v
    nixos-rebuild boot --flake .#{{HOST}} || sudo nixos-rebuild switch --flake .#{{HOST}}
