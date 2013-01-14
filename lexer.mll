{
  open Parser
}
rule token = parse
  | eof { EOF }
  | [' ' '\t' '\n'] { token lexbuf }
  | '(' { LPAREN }
  | ')' { RPAREN }
  | "+" { ADD }
  | "-" { SUB }
  | ['0'-'9']+ { INT (int_of_string (Lexing.lexeme lexbuf)) }
