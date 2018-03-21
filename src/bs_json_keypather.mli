type error =
  Bs_json_keypather_impl.Make(Js.Result).error =
    KeyNotExist of key
  | UnexpectedValueType of key
and key = string
val json_for : Js.String.t -> Js.Json.t -> (Js.Json.t, error) Js.Result.t
val value_for :
  Js.String.t ->
  Js.Json.t -> (Js.Json.t -> 'a option) -> ('a, error) Js.Result.t
val bool_for : Js.String.t -> Js.Json.t -> (bool, error) Js.Result.t
val string_for : Js.String.t -> Js.Json.t -> (Js.String.t, error) Js.Result.t
val float_for : Js.String.t -> Js.Json.t -> (float, error) Js.Result.t
val int_for : Js.String.t -> Js.Json.t -> (int, error) Js.Result.t
val object_for :
  Js.String.t -> Js.Json.t -> (Js.Json.t Js.Dict.t, error) Js.Result.t
val array_for :
  Js.String.t -> Js.Json.t -> (Js.Json.t array, error) Js.Result.t
val is_null_for : Js.String.t -> Js.Json.t -> bool
