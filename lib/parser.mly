%{
%}

%token EOF
%token Plus
%token Minus
%token Times
%token Upon
%token LPA
%token RPA
%token <string> Number

%left Plus Minus
%left Times Upon
%nonassoc neg

%start <Expr.t option> get
%start <Expr.t option> post

%%

get:
  | Upon e = expr EOF
  { Some e}
  | Upon EOF | EOF { None }

post:
  | e = expr EOF
  { Some e }
  | EOF { None }

expr:
  | x = expr Plus y = expr
  { Expr.Add (x, y) }
  | x = expr Minus y = expr
  { Expr.Sub (x, y) }
  | x = expr Times y = expr
  { Expr.Mul (x, y) }
  | x = expr Upon y = expr
  { Expr.Div (x, y) }
  | Minus e = expr
  { Expr.Sub (Expr.zero, e) } %prec neg
  | x = Number
  { Expr.Number x }
  | LPA e = expr RPA
  { e }
