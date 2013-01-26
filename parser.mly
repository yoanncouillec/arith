%token<int> INT
%token ADD SUB MUL DIV MOD LPAREN RPAREN SEMICOL EOF
%left ADD SUB
%left MUL DIV
%left MOD
%start start
%type <Machine.expr_arith list> start

%%

start: 
| es = expressions EOF { es }

expressions:
| e = expression { [e] }
| e = expression SEMICOL rest = expressions { e :: rest }

expression:
| LPAREN e = expression RPAREN { e }
| n = INT { Machine.EConst (n) }
| e1 = expression ADD e2 = expression { Machine.EAdd (e1, e2) }
| e1 = expression SUB e2 = expression { Machine.ESub (e1, e2) }
| e1 = expression MUL e2 = expression { Machine.EMul (e1, e2) }
| e1 = expression DIV e2 = expression { Machine.EDiv (e1, e2) }
| e1 = expression MOD e2 = expression { Machine.EMod (e1, e2) }
