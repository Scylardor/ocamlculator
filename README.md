Ocamlculator
============

This is an attempt at enhancing the classical example of a calculator in OCaml.

Making a basic calculator in OCaml is really easy. Let's try here to go a little further, e.g. compute

floating-point values, do cross-bases calculus and add some common useful mathematic functions.

A graphical user interface would then be great, maybe in GTK.


Components
----------

This project uses a lexical analyzer generated with **ocamllex**, and a parser generated with **ocamlyacc**.

It is intended to move to [menhir](http://gallium.inria.fr/~fpottier/menhir/) when the parser reaches a stable state.

In order to manage infinite numbers, the project will be using the Big_int module in the first versions.

Once it has reached a stable state, I'd like to move to the [ZArith](http://forge.ocamlcore.org/projects/zarith/) library instead ([why?](http://stackoverflow.com/a/10515220/1987466)).

