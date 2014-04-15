open Batteries

type t =
  | Add of (t * t)
  | Sub of (t * t)
  | Mul of (t * t)
  | Div of (t * t)
  | Number of string

val zero : t
val eval : t -> Big_int.t
