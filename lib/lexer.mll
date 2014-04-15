{
  open Batteries
}

let DIGIT = ['0' - '9']

rule main = parse
  | eof                 { Parser.EOF }
  | DIGIT+ as i         { Parser.Number i }
  | '+'                 { Parser.Plus }
  | '-'                 { Parser.Minus }
  | '*'                 { Parser.Times }
  | '/'                 { Parser.Upon }
  | '('                 { Parser.LPA }
  | ')'                 { Parser.RPA }
  | _                   { main lexbuf }
