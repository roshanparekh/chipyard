FIRRTL version 1.2.0
circuit SidebandDeserializer :
  module SidebandDeserializer : @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 206:7]
    input clock : Clock @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 206:7]
    input reset : UInt<1> @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 206:7]
    input io_in_bits : UInt<32> @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 212:14]
    input io_in_valid : UInt<1> @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 212:14]
    input io_out_ready : UInt<1> @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 212:14]
    output io_out_valid : UInt<1> @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 212:14]
    output io_out_bits : UInt<128> @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 212:14]

    reg data_0 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), data_0) @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 222:17]
    reg data_1 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), data_1) @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 222:17]
    reg data_2 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), data_2) @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 222:17]
    reg data_3 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), data_3) @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 222:17]
    reg receiving : UInt<1>, clock with :
      reset => (UInt<1>("h0"), receiving) @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 224:26]
    reg recvCount : UInt<2>, clock with :
      reset => (UInt<1>("h0"), recvCount) @[src/main/scala/chisel3/util/Counter.scala 61:40]
    node wrap_wrap = eq(recvCount, UInt<2>("h3")) @[src/main/scala/chisel3/util/Counter.scala 73:24]
    node _wrap_value_T = add(recvCount, UInt<1>("h1")) @[src/main/scala/chisel3/util/Counter.scala 77:24]
    node _wrap_value_T_1 = tail(_wrap_value_T, 1) @[src/main/scala/chisel3/util/Counter.scala 77:24]
    node _GEN_0 = mux(io_in_valid, _wrap_value_T_1, recvCount) @[src/main/scala/chisel3/util/Counter.scala 118:16 77:15 61:40]
    node _GEN_1 = mux(io_in_valid, wrap_wrap, UInt<1>("h0")) @[src/main/scala/chisel3/util/Counter.scala 118:{16,23} 117:24]
    node _io_out_valid_T = eq(receiving, UInt<1>("h0")) @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 227:19]
    node io_out_bits_lo = cat(data_1, data_0) @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 228:23]
    node io_out_bits_hi = cat(data_3, data_2) @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 228:23]
    node _io_out_bits_T = cat(io_out_bits_hi, io_out_bits_lo) @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 228:23]
    node _data_recvCount = io_in_bits @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 231:{21,21}]
    node _GEN_2 = mux(eq(UInt<1>("h0"), recvCount), _data_recvCount, data_0) @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 222:17 231:{21,21}]
    node _GEN_3 = mux(eq(UInt<1>("h1"), recvCount), _data_recvCount, data_1) @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 222:17 231:{21,21}]
    node _GEN_4 = mux(eq(UInt<2>("h2"), recvCount), _data_recvCount, data_2) @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 222:17 231:{21,21}]
    node _GEN_5 = mux(eq(UInt<2>("h3"), recvCount), _data_recvCount, data_3) @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 222:17 231:{21,21}]
    node _GEN_6 = mux(io_in_valid, _GEN_2, data_0) @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 222:17 230:21]
    node _GEN_7 = mux(io_in_valid, _GEN_3, data_1) @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 222:17 230:21]
    node _GEN_8 = mux(io_in_valid, _GEN_4, data_2) @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 222:17 230:21]
    node _GEN_9 = mux(io_in_valid, _GEN_5, data_3) @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 222:17 230:21]
    node recvDone = _GEN_1 @[src/main/scala/chisel3/util/Counter.scala 117:24]
    node _GEN_10 = mux(recvDone, UInt<1>("h0"), receiving) @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 234:18 224:26 234:30]
    node _T = and(io_out_ready, io_out_valid) @[src/main/scala/chisel3/util/Decoupled.scala 51:35]
    node _GEN_11 = mux(_T, UInt<1>("h1"), _GEN_10) @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 236:{21,33}]
    io_out_valid <= _io_out_valid_T @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 227:16]
    io_out_bits <= _io_out_bits_T @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 228:15]
    data_0 <= _GEN_6
    data_1 <= _GEN_7
    data_2 <= _GEN_8
    data_3 <= _GEN_9
    receiving <= mux(reset, UInt<1>("h1"), _GEN_11) @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 224:{26,26}]
    recvCount <= mux(reset, UInt<2>("h0"), _GEN_0) @[src/main/scala/chisel3/util/Counter.scala 61:{40,40}]
