(* ********** Ocamlculator module ************** *)

let known_bases = ["2"; "8"; "10"; "16"]

let input_base = ref ""
let output_base = ref ""
 

(* Message printing error in case of an unrecognized pattern sequence *)
let lexical_error lexbuf = 
  let badCharPos = lexbuf.Lexing.lex_last_pos in
  print_endline ("Malformed expression (unrecognized character " ^ (String.make 1 (String.get lexbuf.Lexing.lex_buffer badCharPos)) ^ " at position " ^ (string_of_int badCharPos) ^ ")")

(* When an empty line comes from input, the parser raises a Parser_error. *)
(* We must check if this is caused by an empty line, by checking the first character of the input buffer. *)
let not_empty_line = function
  | '\n' -> false
  | _ -> true

let calc = fun () ->
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

let initialize =
  begin
    let speclist = [("-ibase", Arg.Symbol (known_bases, fun ibase -> input_base := ibase), " Specifies the input calculus base");
		    ("-obase", Arg.Symbol (known_bases, fun obase -> output_base := obase), " Specifies the output calculus base");
		   ]
    in let usage_msg = "Ocamlculator is a funny little calculator written in OCaml. Options available:"
       in Arg.parse speclist (fun anon -> print_endline ("Anonymous argument: " ^ anon)) usage_msg;
       calc();
  end
