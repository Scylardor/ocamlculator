Ocamlculator
============

This is an attempt at enhancing the classical example of a calculator in OCaml.

Making a basic calculator in OCaml is really easy. Let's try here to go a little further, like:

* compute floating-point values
* do cross-bases calculus
* use some common useful mathematic functions
* manage several mathematical notations (infix, prefix, postfix)
* make a great graphical user interface.

Actually, this is really a fun-oriented project. The list of fantasies to add to the project may vary.


Components
----------

This project uses a lexical analyzer generated with **ocamllex**, and a parser generated with **ocamlyacc**.

It is intended to move to [menhir](http://gallium.inria.fr/~fpottier/menhir/) when the parser reaches a stable state.

In order to manage infinite numbers, the project will be using the Big_int module in the first versions.

Once it has reached a stable state, I'd like to move to the [ZArith](http://forge.ocamlcore.org/projects/zarith/) library instead ([why?](http://stackoverflow.com/a/10515220/1987466)).


Installation
------------

Currently, a standard installation of OCaml should be enough (`apt-get install ocaml` on Debian-based systems).

Make sure to have a recent version of OCaml (developed with version 3.12.1) and the ocamllex and ocamlyacc tools installed.

Normally, the shell command

    make all

will correctly build the binary "ocamlculator".
