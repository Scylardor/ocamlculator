(* ********** Ocamlculator module ************** *)

let known_bases = ["2"; "8"; "10"; "16"]

let input_base = ref ""
let output_base = ref ""
let zero_div = ref false

(* Message printing error in case of an unrecognized pattern sequence *)
let lexical_error lexbuf = 
  let badCharPos = lexbuf.Lexing.lex_last_pos in
  print_endline ("Malformed expression (unrecognized character " ^ (String.make 1 (String.get lexbuf.Lexing.lex_buffer badCharPos)) ^ " at position " ^ (string_of_int badCharPos) ^ ")")


let calc = fun () ->
  try
    let lexbuf = Lexing.from_channel stdin in
    while true do
      try
	let result = Parser.main Lexer.token lexbuf in
	print_endline (Big_int.string_of_big_int result); flush stdout
      with
      (* When an empty line comes from input, the parser raises a Parser_error. *)
      | Parsing.Parse_error ->
	if lexbuf.Lexing.lex_buffer.[0] != '\n' then
	  if !(zero_div) = true then (
	    print_endline "Division by zero.";
	    zero_div := false;
	  )
	  else print_endline "Malformed expression (parsing error)." 
      | Failure explain ->
	lexical_error lexbuf;
	Lexing.flush_input lexbuf;
      | Division_by_zero ->
	zero_div := true;
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
