/* File parser.mly */
%token <int> INT
%token ADD SUB MULT DIV
%token LPAREN RPAREN
%token EOL
%left ADD SUB		/* lowest precedence */
%left MULT DIV		/* medium precedence */
%right CARET		/* exponentiation */
%nonassoc UMINUS        /* highest precedence */
%start main             /* the entry point */
%type <int> main
%%
main:
expr EOL                { $1 }
  ;
  expr:
    INT { $1 }
 | LPAREN expr RPAREN      { $2 }
 | expr ADD expr           { $1 + $3 }
 | expr SUB expr           { $1 - $3 }
 | expr MULT expr          { $1 * $3 }
 | expr DIV expr           { $1 / $3 }
 | SUB expr %prec UMINUS   { - $2 }
  ;
  
  
