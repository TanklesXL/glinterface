import gleam/int
import gleam/list
import glinterface.{impl, init, method}

type Counter {
  Counter(record: CounterRecord)
}

type CounterRecord {
  CounterRecord(up: fn(Int) -> Counter, down: fn(Int) -> Counter, value: Int)
}

pub fn int_counter_test() {
  let counter = {
    use value <- init(fn(x) { x }, 1)
    use up <- method(int.add)
    use down <- method(int.subtract)
    use <- impl
    Counter(CounterRecord(up:, down:, value:))
  }
  let counter = counter.record.up(2)
  assert counter.record.value == 3
  let counter = counter.record.down(10)
  assert counter.record.value == -7
}

pub fn list_counter_test() {
  let counter = {
    use value <- init(with: list.length, from: list.repeat(Nil, 1))
    use up <- method(fn(state, change) {
      list.append(state, list.repeat(Nil, change))
    })
    use down <- method(list.drop)
    use <- impl()
    Counter(CounterRecord(up:, down:, value:))
  }
  let counter = counter.record.up(2)
  assert counter.record.value == 3
  let counter = counter.record.down(10)
  assert counter.record.value == 0
}
