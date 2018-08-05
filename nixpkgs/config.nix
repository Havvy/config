{
  allowUnfree = true;

  packageOverrides = pkgs: rec {
    rustNightly = pkgs.callPackage ./rust-nightly.nix {};
  };

  # Turn on when building in ~/workspace/nixpkgs
  nix.useSandbox = true;
}
