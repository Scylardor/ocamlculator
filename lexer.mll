  (* File lexer.mll *)
  {
    open Parser        (* The type token is defined in parser.mli *)
    open Big_int
    exception Eof
  }
    rule token = parse
      [' ' '\t']     { token lexbuf }     (* skip blanks *)
          | ['\n']        { EOL }
          | ['0'-'9']+ as lxm { INT(big_int_of_string lxm) }
          | '+'            { ADD }
          | '-'            { SUB }
          | '*'            { MULT }
          | '/'            { DIV }
          | '('            { LPAREN }
          | ')'            { RPAREN }
          | eof            { raise Eof }
