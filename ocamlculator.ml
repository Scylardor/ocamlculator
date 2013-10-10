(* ********** Ocamlculator module ************** *)

(* Message printing error in case of an unrecognized pattern sequence *)
let lexical_error lexbuf = 
  let badCharPos = lexbuf.Lexing.lex_last_pos in
  print_endline ("Malformed expression (unrecognized character " ^ (String.make 1 (String.get lexbuf.Lexing.lex_buffer badCharPos)) ^ " at position " ^ (string_of_int badCharPos) ^ ")")

(* When an empty line comes from input, the parser raises a Parser_error. *)
(* We must check if this is caused by an empty line, by checking the first character of the input buffer. *)
let not_empty_line = function
  | '\n' -> false
  | _ -> true

let calc = 
  try
    let lexbuf = Lexing.from_channel stdin in
    while true do
      try
	let result = Parser.main Lexer.token lexbuf in
	print_int result; print_newline(); flush stdout
      with
      | Parsing.Parse_error -> if not_empty_line lexbuf.Lexing.lex_buffer.[0] then raise Parsing.Parse_error
      | Failure explain ->
	lexical_error lexbuf;
	Lexing.flush_input lexbuf;
    done
  with Lexer.Eof -> print_endline "Computation finished."

let init =
  calc

