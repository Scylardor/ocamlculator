  (* File lexer.mll *)
  {
    open Parser        (* The type token is defined in parser.mli *)
    exception Eof
  }
    rule token = parse
      [' ' '\t']     { token lexbuf }     (* skip blanks *)
          | ['\n']        { EOL }
          | ['0'-'9']+ as lxm { VAL(BaseConverter.Big_int_BaseConverter.value_of_dec lxm)}
	  | "0x"['0'-'9''A'-'F']+ as lxm {VAL(BaseConverter.Big_int_BaseConverter.value_of_hex lxm)}
	  | "0b"['0'-'1']+ as lxm {VAL(BaseConverter.Big_int_BaseConverter.value_of_bin lxm)}
	  | "0o"['0'-'7']+ as lxm {VAL(BaseConverter.Big_int_BaseConverter.value_of_oct lxm)}
          | '+'            { ADD }
          | '-'            { SUB }
          | '*'            { MULT }
          | '/'            { DIV }
          | '('            { LPAREN }
          | ')'            { RPAREN }
          | eof            { raise Eof }
