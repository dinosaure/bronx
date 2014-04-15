open Batteries

type t =
  | Add of (t * t)
  | Sub of (t * t)
  | Mul of (t * t)
  | Div of (t * t)
  | Number of string

let zero = Number "0"

let rec eval =
  Big_int.(function
      | Add (a, b) -> (eval a) + (eval b)
      | Sub (a, b) -> (eval a) - (eval b)
      | Mul (a, b) -> (eval a) * (eval b)
      | Div (a, b) -> (eval a) / (eval b)
      | Number a -> of_string a
    )
