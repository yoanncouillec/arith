{
  open Parser
}
rule token = parse
  | eof { EOF }
  | ';' { SEMICOL }  
  | [' ' '\t' '\n'] { token lexbuf }
  | '(' { LPAREN }
  | ')' { RPAREN }
  | "+" { ADD }
  | "-" { SUB }
  | "*" { MUL }
  | "/" { DIV }
  | "%" { MOD }
  | ['0'-'9']+ { INT (int_of_string (Lexing.lexeme lexbuf)) }
