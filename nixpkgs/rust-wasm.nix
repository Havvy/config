project-name:

with import <nixpkgs> {};

let
  date = "2017-05-03";
  rustpkgs = callPackage /home/havvy/.nixpkgs/rust-nightly.nix {};

  rustWithWasm = rustpkgs.rustcWithSysroots {
    rustc = rustpkgs.rustc { inherit date; };
    sysroots = map rustpkgs.rust-std [
      { inherit date; } # native stdlib, needed for build.rs and procedural macros.
      {
        system = "wasm32-unknown-emscripten";
        inherit date;
      }
    ];
  };

  cargo = rustpkgs.cargo { inherit date; };
in stdenv.mkDerivation {
    name = "rust-with-wasm";
    shellHook = ''
      # Set some variables for the terminal prompt.
      green=$(tput setaf 2)
      bold=$(tput bold)
      reset=$(tput sgr0) # Resets other styles. Broken in some unknown way?

      # # Everything between \[ and \] are considerd as 0 characters long for word-wrap.
      # \u is the username.
      # \w is the path (relative to ~ if possible)
      export PS1="\n\[$green$bold\][\u@rust:\w]\$\[$reset\] "

      # Unset the variables used for the terminal prompt.
      unset green
      unset bold
      unset clear

      # Go directly to the Rust directory.
      cd ~/workspace/${project-name}
    '';
    buildInputs = [
        cmake # Wanted by emscripten
        emscripten
        rustWithWasm
        cargo
    ];
}