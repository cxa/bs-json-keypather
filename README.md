# JSON Keypath Navigator for BuckleScript

Navigate JSON with keypath.

## Basic usage

Add `@cxa/bs-json-keypather` to your dependencies, and configure your `bsconfig.json` like:

```json
{
  "bs-dependencies": ["@cxa/bs-json-keypather"]
}
```

For this JSON:

```json
{
  "title": { "main": "Bs_json_keypather", "sub": "is awesome" },
  "version": { "major": 1, "minor": 2 },
  "version_float": 1.2,
  "production_ready": true,
  "reason": null,
  "arr": [4, 5, 6]
}
```

You can navigate main title with `Bs_json_keypather.string_for "title.main" json`. More:

```ocaml
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
```

## Advance usage

Use your favorite `Result` type e.g. `CCResult` with functor `Bs_json_keypather_impl.Make`.

```ocaml
module My_json_keypather =
  Bs_json_keypather_impl.Make(CCResult)
```

## Development

* `npm run/yarn watch`
* `npm run/yarn test`
