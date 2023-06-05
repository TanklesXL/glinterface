import gleeunit
import gleeunit/should
import glinterface.{add, impl, init, map, wrap}
import gleam/function.{identity}
import gleam/list

pub fn main() {
  gleeunit.main()
}

pub fn int_counter_test() {
  let c = int_counter(1)
  let c = c.record.up(2)
  should.equal(c.record.value, 3)
  let c = c.record.down(10)
  should.equal(c.record.value, -7)
}

pub fn list_counter_test() {
  let c = list_counter(1)
  let c = c.record.up(2)
  should.equal(c.record.value, 3)
  let c = c.record.down(10)
  should.equal(c.record.value, 0)
}

/// type Counter
///   = Counter CounterRecord
type Counter {
  Counter(record: CounterRecord)
}

/// type alias CounterRecord =
///   { up : Int -> Counter
///   , down : Int -> Counter
///   , value : Int
///   }
type CounterRecord {
  CounterRecord(up: fn(Int) -> Counter, down: fn(Int) -> Counter, value: Int)
}

/// intCounter : Int -> Counter
/// intCounter =
///     impl CounterRecord
///        |> wrap (\raise rep n -> raise (rep + n))
///         |> wrap (\raise rep n -> raise (rep - n))
///         |> add identity
///         |> map Counter
///         |> init (\raise rep -> raise rep)
///
fn int_counter(i: Int) -> Counter {
  impl(function.curry3(CounterRecord))
  |> wrap(fn(raise, rep) { fn(n) { raise(rep + n) } })
  |> wrap(fn(raise, rep) { fn(n) { raise(rep - n) } })
  |> add(identity)
  |> map(Counter)
  |> init(fn(raise, n) { raise(n) }, i)
}

/// listCounter : Int -> Counter
/// listCounter =
///     impl CounterRecord
///         |> wrap (\raise rep n -> raise (List.repeat n () ++ rep))
///         |> wrap (\raise rep n -> raise (List.drop n rep))
///         |> add List.length
///         |> map Counter
///         |> init (\raise n -> raise (List.repeat n ()))
///
fn list_counter(i: Int) -> Counter {
  impl(function.curry3(CounterRecord))
  |> wrap(fn(raise, rep) {
    fn(n) { raise(list.append(list.repeat(Nil, n), rep)) }
  })
  |> wrap(fn(raise, rep) { fn(n) { raise(list.drop(rep, n)) } })
  |> add(list.length)
  |> map(Counter)
  |> init(fn(raise, n) { raise(list.repeat(Nil, n)) }, i)
}
