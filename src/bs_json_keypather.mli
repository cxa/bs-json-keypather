type error =
  Bs_json_keypather_impl.Make(Belt.Result).error =
    KeyNotExist of key
  | UnexpectedValueType of key
and key = string
val json_for : Js.String.t -> Js.Json.t -> (Js.Json.t, error) Belt.Result.t
val value_for :
  Js.String.t ->
  Js.Json.t -> (Js.Json.t -> 'a option) -> ('a, error) Belt.Result.t
val bool_for : Js.String.t -> Js.Json.t -> (bool, error) Belt.Result.t
val string_for : Js.String.t -> Js.Json.t -> (Js.String.t, error) Belt.Result.t
val float_for : Js.String.t -> Js.Json.t -> (float, error) Belt.Result.t
val int_for : Js.String.t -> Js.Json.t -> (int, error) Belt.Result.t
val object_for :
  Js.String.t -> Js.Json.t -> (Js.Json.t Js.Dict.t, error) Belt.Result.t
val array_for :
  Js.String.t -> Js.Json.t -> (Js.Json.t array, error) Belt.Result.t
val is_null_for : Js.String.t -> Js.Json.t -> bool
