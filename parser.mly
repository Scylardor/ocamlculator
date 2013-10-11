/* File parser.mly */
%token <Big_int.big_int> INT
%token ADD SUB MULT DIV
%token LPAREN RPAREN
%token EOL
%left ADD SUB		/* lowest precedence */
%left MULT DIV		/* medium precedence */
%nonassoc UMINUS        /* highest precedence */
%start main             /* the entry point */
%type <Big_int.big_int> main
%%
main:
expr EOL                { $1 }
  ;
  expr:
    INT { $1 }
 | LPAREN expr RPAREN      { $2 }
 | expr ADD expr           { Big_int.add_big_int $1 $3 }
 | expr SUB expr           { Big_int.sub_big_int $1 $3 }
 | expr MULT expr          { Big_int.mult_big_int $1 $3 }
 | expr DIV expr           { Big_int.div_big_int $1 $3 }
 | SUB expr %prec UMINUS   { Big_int.minus_big_int $2 }
  ;
