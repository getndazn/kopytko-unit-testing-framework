# KopytkoFrameworkTestSuite API

## Methods

- [Methods](#methods)
- [Reference](#reference)
  - [`assertDataWasSetOnStore`](#assertdatawassetonstore)
  - [`assertRequestWasMade`](#assertrequestwasmade)

---

## Reference

### `assertDataWasSetOnStore`

It checks if data was set on `Store` (part of [Roku Framework](https://github.com/getndazn/kopytko-framework)).

Params:

- `data`: `Object` - the data that should be set on `Store`
- `msg = ""`: `String` - additional message when test fails

### `assertRequestWasMade`

It checks if request was made via `createRequest` (part of [Roku Framework](https://github.com/getndazn/kopytko-framework)).

Params:

- `params = {}`: `Object` - arguments passed to `createRequest` method
- `options = {}`: `Object`
  - `times`: `Integer` - how many times it should be called
  - `strict`: `Boolean` - affects how the params are compared. When `true` the params object must match the arguments types and values (1 to 1 equality). If `false` the params object can contain some of the passed arguments that are tested
- `msg = ""`: `String` - additional message when test fails
