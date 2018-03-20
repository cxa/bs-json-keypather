module type Result =
sig type ('good, 'bad) t = Ok of 'good | Error of 'bad end
module Make :
  functor (R : Result) ->
  sig
    type error = KeyNotExist of key | UnexpectedValueType of key
    and key = string
    val json_for : Js.String.t -> Js.Json.t -> (Js.Json.t, error) R.t
    val value_for :
      Js.String.t ->
      Js.Json.t -> (Js.Json.t -> 'a option) -> ('a, error) R.t
    val bool_for : Js.String.t -> Js.Json.t -> (Js.boolean, error) R.t
    val string_for : Js.String.t -> Js.Json.t -> (Js.String.t, error) R.t
    val float_for : Js.String.t -> Js.Json.t -> (float, error) R.t
    val int_for : Js.String.t -> Js.Json.t -> (int, error) R.t
    val object_for :
      Js.String.t -> Js.Json.t -> (Js.Json.t Js.Dict.t, error) R.t
    val array_for :
      Js.String.t -> Js.Json.t -> (Js.Json.t array, error) R.t
    val is_null_for : Js.String.t -> Js.Json.t -> bool
  end
