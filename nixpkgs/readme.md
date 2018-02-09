## Nix

Nix is a pure-functional package manager, operating system distrubution, and programming language.

### Package Management

#### The Nix Store

Everything gets stored in `/nix/store`. Each thing stored is called `derivation`.

#### Channels

##### Tool: nix-channel

##### Nixpkgs

Nixpkgs is the centralized channel of nix packages (what's a package?).

It contains packages for most common programs in their stable form.

It has a stable version and an unstable version. The unstable version is what I use.

### Language

Nix expressions describe packages and how to build them.

#### Evaluation

Nix is lazy. Values only get evaluated as they are necessary. For example,
in the following expression, `err` doesn't get evaluated because it's not
needed in evaluating `b`.

let err = builtins.div 1 0; b = "okay"; in b

Be wary of recursive shadowing. This happens in two places - recursive sets and let expressions.
In recursive sets, all expressions have in scope all keys in the set, shadowing values outside.

#### Types

| integer    | 42                    | No floats
| string     | "xyz" and ''xyz''     | "${foo}" for string interpolation. To escape, "a\${}b" or ''a''${}b''
| path       | /foo/bar              |
| boolean    | true and false        |
| null       | null                  |
| lists      | [x y z]               | Space in lists binds stronger than function application.
| sets       | {x = y; y = z;}       | List of string key -> nix expr. Access is `set.key`.
|            | rec {x = y; y = "z";} | Recursive sets - keys of the set are in scope in the expressions in the set.
|            | {inherit foo;}        | Similar to `{foo=foo;}`.
|            |                       | Note that `rec {foo = foo;}` is an infinite loop while `{inherit foo;}` is not.
| functions  | arg: expr             | 

##### Derivation

A description for how to build a ???.

{
    all = ?;
    builder = ?;
    drvAttrs = DerivationInput;
    drvPath = Path;
    name = ?;
    out = ?;
    outPath = Path;
    outputName = ?;
    system = ?;
    type = "derivation";
}

* drvAttrs is the input passed to create the derivation.
* drvPath is the Path that the derivation is located at. So /nix/store/hash-name.drv
* outPath is the Path that the output of the derivation is located at. So /nix/store/hash-name

The has for a derivation and its output will be different.

##### DerivationInput

A desciption for how to build a derivation. Passed to `derivation`.

{
    name = String;
    system = System;
    builder = String;
    _ = ?;
}

The name is the name of the 

#### Argument Set Patterns

We can substitute the `arg` in a function with a pattern for a set.

E.g., let us consider the function `add = arg: arg.lhs + arg.rhs`

We can use patterns to rewrite this almost as `add = {lhs, rhs}: lhs + rhs`.
The almost is that the pattern adds an assertion that the set passed to the function
contains only the keys put into the set, no more and no fewer.

We can relax the assertion in two ways.

We can make a key optional by giving a default value with the `?` operator. For
example, we can make it so that if there's no `rhs` passed, it will default to `0`.
`add = {lhs, rhs ? 0}: lhs + rhs`

We can also allow other unspecified keys by adding `..` to the set pattern.
`add = {lhs, rhs, ..}: lhs + rhs`

Finally, we can have both a variable representing the set and the args at the same
time with `identifier @ pattern`
`add = set @ {lhs, rhs}: lhs + set.rhs`

#### Expressions

@name = Variable binding
%name = Nix subexpression

* %function %value
** Function application.
** All functions only take a single argument.
** Functions that take multiple args generally are functions that evaluate to functions.
** So partial application works.

* if %predicate then %consequent else %antecedant
** The `else` branch is required.

* let @var = %value; in %expression
** Can have multiple var=value pairs.
** expression has each var in scope.

* with %set; %expr
** Puts all keys in set in scope in expr
** Except does not do shadowing.

#### Functions

import Path -> Expr

Evaluates to the nix expression located at the file specified by the path.

The expression evaluated does not get the scope of the caller of `import`, but rather a fresh scope.

--

derivation { name = String; system = System; builder = String; (plus more) } -> Derivation

Creates a derivation. This actually puts a `.drv` into /nix/store. Then returns 

#### Tool: nix-repl

Install via `nix-env -iA nixpkgs.nix-repl. It does not come preloaded.

Exit with ctrl+z.