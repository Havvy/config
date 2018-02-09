# Change the NIX_PATH to actually use my user and not root.
NIX_PATH=nixpkgs=/nix/var/nix/profiles/per-user/havvy/channels/nixpkgs:nixos-config=/etc/nixos/configuration.nix:/nix/var/nix/profiles/per-user/havvy/channels:home=/home/havvy/.nixpkgs

dev () {
    nix-shell ~/.nixpkgs/shell/$1.nix
}

run () {
    $@ &> /dev/null &
}

ghclone () {
    git clone https://github.com/$1/$2.git
}