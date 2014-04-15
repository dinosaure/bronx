open Printf
open Batteries
open Lwt
open Cohttp
open Cohttp_lwt_unix

let port = 8080
let address = "127.0.0.1"

let execute ?(post=false) data =
  let parse = if post then Parser.post else Parser.get in
  try
    (parse Lexer.main (Lexing.from_string data))
    |> function
    | None ->
      Server.respond_string ~status:`Internal_server_error ~body:"Empty expression" ()
    | Some e ->
      Server.respond_string
        ~status:`OK
        ~body:(Big_int.to_string @@ Expr.eval e) ()
  with _ ->
    Server.respond_string
      ~status:`Internal_server_error
      ~body:("Bad expression" ^ data) ()

let make_server () =
  let callback conn_id req body =
    match Uri.path (Request.uri req) with
    | "" | "/" ->
      Server.respond_string ~status:`OK ~body:"Hello World!" ()
    | "/post" ->
      Cohttp_lwt_body.to_string body >>= fun expr ->
      execute ~post:true expr
    | expr -> execute expr
  in
  let conn_closed _ () = () in
  let config = { Server.callback; conn_closed } in
  Server.create ~address ~port config

let _ =
  Lwt_unix.run (make_server ())
