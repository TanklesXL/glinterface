import gleam/function.{identity}
import gleam/int
import gleam/list
import gleeunit
import glinterface.{add, impl, init, map, wrap}

pub fn main() {
  gleeunit.main()
}

fn curry3(f: fn(a, b, c) -> d) -> fn(a) -> fn(b) -> fn(c) -> d {
  fn(a) { fn(b) { fn(c) { f(a, b, c) } } }
}

pub fn int_counter_test() {
  let c = int_counter(1)
  let c = c.record.up(2)
  assert c.record.value == 3
  let c = c.record.down(10)
  assert c.record.value == -7
}

pub fn list_counter_test() {
  let c = list_counter(1)
  let c = c.record.up(2)
  assert c.record.value == 3
  let c = c.record.down(10)
  assert c.record.value == 0
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
  impl(curry3(CounterRecord))
  |> wrap(int.add)
  |> wrap(int.subtract)
  |> add(identity)
  |> map(Counter)
  |> init(i)
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
  impl(curry3(CounterRecord))
  |> wrap(fn(state, change) { list.append(state, list.repeat(Nil, change)) })
  |> wrap(list.drop)
  |> add(list.length)
  |> map(Counter)
  |> init(list.repeat(Nil, i))
}
