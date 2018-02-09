{
  allowUnfree = true;

  packageOverrides = pkgs: rec {
    rustNightly = pkgs.callPackage ./rust-nightly.nix {};

    # emscripten = let nixpkgs2 = import /home/havvy/workspace/nixpkgs {}; in nixpkgs2.emscripten;
  };
}
