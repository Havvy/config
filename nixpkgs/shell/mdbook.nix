with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "mdbook";

  shellHook = ''
    # Set some variables for the terminal prompt.
    green=$(tput setaf 2)
    bold=$(tput bold)
    reset=$(tput sgr0) # Resets other styles. Broken in some unknown way?

    # # Everything between \[ and \] are considerd as 0 characters long for word-wrap.
    # \u is the username.
    # \w is the path (relative to ~ if possible)
    export PS1="\n\[$green$bold\][\u@mdbook:\w]\$\[$reset\] "

    # Unset the variables used for the terminal prompt.
    unset green
    unset bold
    unset clear

    # Go directly to the Gald directory.
    cd ~/workspace/rust/mdbook
  '';

  buildInputs = [
    rust.cargo
    rust.rustc
  ];
}