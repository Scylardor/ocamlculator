(* ********** Ocamlculator module ************** *)

type calc_error = Zero_div | Empty_line | Parsing_error | No_error

let known_bases = ["2"; "8"; "10"; "16"]

let input_base = ref ""
let output_base = ref ""
let calc_err = ref No_error

(* Prints errors in case of calculation errors (division by zero, etc.) *)
let parsing_error = function
  | Zero_div -> print_endline "Division by zero"
  | Empty_line -> ()
  | _ -> print_endline "Malformed expression (calculation error)"

let calc = fun () ->
  try
    let lexbuf = Lexing.from_channel stdin in
    while true do
      try
	let result = Parser.main Lexer.token lexbuf in
	print_endline (Big_int.string_of_big_int result);
	flush stdout;
	Lexing.flush_input lexbuf;
      with
      | Parsing.Parse_error -> 
	(* When an empty line comes from input, the parser raises a Parser_error. *)
	if lexbuf.Lexing.lex_buffer.[0] == '\n' then
	  calc_err := Empty_line;
	parsing_error !(calc_err);
	calc_err := No_error;
      | Failure explain ->
	let badCharPos = lexbuf.Lexing.lex_last_pos in
	let badChar = String.make 1 (String.get lexbuf.Lexing.lex_buffer badCharPos) in
	print_endline ("Malformed expression (unrecognized character " ^ badChar ^ " at position " ^ (string_of_int badCharPos) ^ ")");
	  Lexing.flush_input lexbuf;
      | Division_by_zero ->
	(* A parsing error is also raised in case of a division by zero. *)
	(* Set the error to "division by zero" to let the Parse_error filter know what it is *)
	calc_err := Zero_div;
    done
  with Lexer.Eof -> print_endline "Computation finished."

    
let initialize =
  begin
    let speclist = [("-ibase", Arg.Symbol (known_bases, fun ibase -> input_base := ibase), " Specifies the input calculus base");
		    ("-obase", Arg.Symbol (known_bases, fun obase -> output_base := obase), " Specifies the output calculus base");
		   ]
    in let usage_msg = "Ocamlculator is a funny little calculator written in OCaml. Options available:"
       in Arg.parse speclist (fun anon -> print_endline ("File name: " ^ anon)) usage_msg;
       calc();
  end
