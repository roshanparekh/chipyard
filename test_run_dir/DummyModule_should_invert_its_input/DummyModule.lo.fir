FIRRTL version 1.2.0
circuit DummyModule :
  module DummyModule : @[generators/uciedigital/src/main/scala/DummyModule.scala 5:7]
    input clock : Clock @[generators/uciedigital/src/main/scala/DummyModule.scala 5:7]
    input reset : UInt<1> @[generators/uciedigital/src/main/scala/DummyModule.scala 5:7]
    input io_a : UInt<1> @[generators/uciedigital/src/main/scala/DummyModule.scala 6:14]
    output io_b : UInt<1> @[generators/uciedigital/src/main/scala/DummyModule.scala 6:14]

    node _io_b_T = not(io_a) @[generators/uciedigital/src/main/scala/DummyModule.scala 11:11]
    io_b <= _io_b_T @[generators/uciedigital/src/main/scala/DummyModule.scala 11:8]
