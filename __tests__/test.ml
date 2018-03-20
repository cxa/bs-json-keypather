open Jest
open Expect
open Bs_json_keypather

let obj = [%bs.obj
  {
    title = [%bs.obj
      { main = "Bs_json_keypather"
      ; sub = "is awesome"
      }]
  ; version = [%bs.obj
      { major = 1
      ; minor = 2
      }]
  ; version_float = 1.2
  ; production_ready = Js.true_
  ; reason = Js.Null.empty
  ; arr = [| 4; 5; 6|]
  }]

let is_ok r =
  match r with
  | Js.Result.Ok _ -> true
  | _ -> false

let get_ok_exn r =
  match r with
  | Js.Result.Ok a -> a
  | _ -> failwith "Result is error, fail to extract value"

let json = Js.Json.stringifyAny obj |> Js.Option.getExn |> Js.Json.parseExn

let () =
  test
    "bool_for"
    (fun () ->
       bool_for "production_ready" json
       |> is_ok
       |> expect
       |> toBe true
    )
  ;
  test
    "string_for"
    (fun () ->
       string_for "title.sub" json
       |> get_ok_exn
       |> expect
       |> toBe "is awesome"
    )
  ;
  test "float_for"
    (fun () ->
       float_for "version_float" json
       |> get_ok_exn
       |> expect
       |> toBeCloseTo 1.2
    )
  ;
  test "int_for"
    (fun () ->
       int_for "version.minor" json
       |> get_ok_exn
       |> expect
       |> toBe 2
    )
  ;
  test "object_for"
    (fun () ->
       object_for "title" json
       |> is_ok
       |> expect
       |> toBe true
    )
  ;
  test "array_for"
    (fun () ->
       let arr =
         array_for "arr" json
         |> get_ok_exn
       in
       Array.length arr
       |> expect
       |> toBe 3
    )
  ;
  test "is_null_for"
    (fun () ->
       is_null_for "reason" json
       |> expect
       |> toBe true
    )
  ;
  test "is_null_for/2"
    (fun () ->
       is_null_for "no_exist" json
       |> expect
       |> toBe false
    )
  ;
  test "is_null_for/3"
    (fun () ->
       is_null_for "arr" json
       |> expect
       |> toBe false
    )