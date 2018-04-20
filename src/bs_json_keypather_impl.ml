module type Result = sig
  type (+'good, +'bad) t =
    | Ok of 'good
    | Error of 'bad
end

module Make (R: Result) = struct
  type error =
    | KeyNotExist of key
    | UnexpectedValueType of key
  and key = string

  let ok a = R.Ok a

  let not_exist key = R.Error (KeyNotExist key)

  let unexpected key = R.Error (UnexpectedValueType key)

  let map_result f r =
    match r with
    | R.Ok o -> R.Ok (f o)
    | R.Error e -> R.Error e

  let flatmap_result f r =
    match r with
    | R.Ok o -> f o
    | R.Error e -> R.Error e

  let map_opt_with_default ~default f opt =
    match opt with
    | Some a -> f a
    | None -> default

  let json_for_maybe_index_key orig_err key json =
    try
      let idx = int_of_string key in
      Js.Json.decodeArray json
      |> map_opt_with_default
        ~default:(unexpected key)
        (fun arr ->
           try
             ok @@ Array.get arr idx
           with
             _ -> not_exist key
        )
    with
      _ -> orig_err

  let dict_get_as_result key dict =
    Js.Dict.get dict key
    |> map_opt_with_default
      ~default:(not_exist key)
      ok

  let json_for_key key json =
    Js.Json.decodeObject json
    |> map_opt_with_default
      ~default:(json_for_maybe_index_key (unexpected key) key json)
      (dict_get_as_result key)

  exception Stop_folding of (Js.Json.t, error) R.t

  let json_for keypath json =
    let keys = Js.String.split "." keypath in
    try
      keys
      |> Array.fold_left
        (fun acc key ->
           let r = json_for_key key acc in
           match r with
           | R.Ok j -> j
           | _ ->  raise (Stop_folding r) (* Use exception to break *)
        )
        json
      |> ok
    with
    | Stop_folding r -> r

  let value_for keypath json transform =
    json_for keypath json
    |> flatmap_result
      (fun j ->
         match transform j with
         | Some v -> ok v
         | None ->
           let keys = Js.String.split "." keypath in
           let last_key = Array.get keys (Array.length keys - 1) in
           unexpected last_key
      )

  let bool_for keypath json =
    value_for keypath json Js.Json.decodeBoolean

  let string_for keypath json =
    value_for keypath json Js.Json.decodeString

  let float_for keypath json =
    value_for keypath json Js.Json.decodeNumber

  let int_for keypath json =
    float_for keypath json
    |> map_result int_of_float

  let object_for keypath json =
    value_for keypath json Js.Json.decodeObject

  let array_for keypath json =
    value_for keypath json Js.Json.decodeArray

  let is_null_for keypath json =
    match value_for keypath json Js.Json.decodeNull with
    | R.Ok _ -> true
    | _ -> false

end
