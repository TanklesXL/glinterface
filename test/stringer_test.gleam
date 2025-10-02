import gleam/int
import gleam/string
import glinterface.{impl, init, method}

type Stringer {
  Stringer(record: StringerRecord)
}

type StringerRecord {
  StringerRecord(
    append: fn(String) -> Stringer,
    double: fn() -> Stringer,
    value: String,
  )
}

pub fn string_stringer_test() {
  let stringer = {
    use value <- init(with: fn(s) { s }, from: "moo")
    use append <- method(string.append)
    use double <- method(fn(rep, _) { string.repeat(rep, 2) })
    use <- impl
    Stringer(StringerRecord(append:, double: fn() { double(Nil) }, value:))
  }
  let stringer = stringer.record.append("ps")
  assert stringer.record.value == "moops"
  let stringer = stringer.record.double()
  assert stringer.record.value == "moopsmoops"
}

pub fn int_stringer_test() {
  let stringer = {
    use value <- init(with: int.to_string, from: 1)
    use append <- method(fn(i, s) { int.add(i, string.length(s)) })
    use double <- method(fn(i, _) { int.add(i, i) })
    use <- impl
    Stringer(StringerRecord(append:, double: fn() { double(Nil) }, value:))
  }
  let stringer = stringer.record.append("abc")
  assert stringer.record.value == "4"
  let stringer = stringer.record.double()
  assert stringer.record.value == "moopsmoops"
}
