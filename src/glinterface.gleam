/// impl : t -> (raise -> rep -> t)
/// impl constructor =
///   \_ _ -> constructor
///
pub fn impl(constructor: t) -> fn(raise, rep) -> t {
  fn(_, _) { constructor }
}

/// wrap : (raise -> rep -> t) -> (raise -> rep -> (t -> q)) -> (raise -> rep -> q)
/// wrap method pipeline raise rep =
///   method raise rep |> pipeline raise rep
pub fn wrap(
  pipeline: fn(raise, rep) -> fn(t) -> q,
  method: fn(raise, rep) -> t,
) -> fn(raise, rep) -> q {
  fn(raise, rep) {
    method(raise, rep)
    |> pipeline(raise, rep)
  }
}

/// add : (rep -> t) -> (raise -> rep -> (t -> q)) -> (raise -> rep -> q)
/// add method pipeline raise rep =
///   method rep |> pipeline raise rep
///
pub fn add(
  pipeline: fn(raise, rep) -> fn(t) -> q,
  method: fn(rep) -> t,
) -> fn(raise, rep) -> q {
  fn(raise, rep) {
    method(rep)
    |> pipeline(raise, rep)
  }
}

/// map : (a -> b) -> (raise -> rep -> a) -> (raise -> rep -> b)
/// map op pipeline raise rep =
///   pipeline raise rep |> op
///
pub fn map(pipeline: fn(raise, rep) -> a, op: fn(a) -> b) -> fn(raise, rep) -> b {
  fn(raise, rep) {
    pipeline(raise, rep)
    |> op
  }
}

/// init : ((rep -> sealed) -> flags -> output) -> ((rep -> sealed) -> rep -> sealed) -> flags -> output
/// init initRep pipeline flags =
///   let
///     raise : rep -> sealed
///     raise rep =
///         pipeline raise rep
/// in
/// initRep raise flags
///
pub fn init(
  pipeline: fn(fn(rep) -> sealed, rep) -> sealed,
  init_rep: fn(fn(rep) -> sealed, flags) -> output,
  flags: flags,
) -> output {
  raise(pipeline, _)
  |> init_rep(flags)
}

fn raise(pipeline: fn(fn(rep) -> sealed, rep) -> sealed, rep: rep) -> sealed {
  raise(pipeline, _)
  |> pipeline(rep)
}
