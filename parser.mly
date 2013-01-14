%token<int> INT
%token ADD SUB LPAREN RPAREN EOF
%left ADD SUB
%start start
%type <Machine.expr_arith> start

%%

start: 
| expression EOF { $1 }

expression:
| LPAREN expression RPAREN { $2 }
| INT { Machine.EConst ($1) }
| expression ADD expression { Machine.EAdd ($1, $3) }
| expression SUB expression { Machine.ESub ($1, $3) }
