pub fn impl(f) -> fn(raise, rep) -> b {
  fn(_, _) { f() }
}

pub fn method(
  method: fn(rep, change) -> rep,
  pipeline: fn(fn(change) -> sealed) -> fn(fn(rep) -> sealed, rep) -> q,
) -> fn(fn(rep) -> sealed, rep) -> q {
  fn(raise, rep) {
    pipeline(fn(change) { raise(method(rep, change)) })(raise, rep)
  }
}

pub fn init(
  with calculate_value: fn(rep) -> t,
  from rep: rep,
  in pipeline: fn(t) -> fn(fn(rep) -> sealed, rep) -> sealed,
) -> sealed {
  init(calculate_value, _, pipeline)
  |> pipeline(calculate_value(rep))(rep)
}
