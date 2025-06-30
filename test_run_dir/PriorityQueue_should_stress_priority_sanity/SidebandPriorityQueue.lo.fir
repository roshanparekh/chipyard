FIRRTL version 1.2.0
circuit SidebandPriorityQueue :
  module Queue4_UInt128 : @[src/main/scala/chisel3/util/Decoupled.scala 243:7]
    input clock : Clock @[src/main/scala/chisel3/util/Decoupled.scala 243:7]
    input reset : UInt<1> @[src/main/scala/chisel3/util/Decoupled.scala 243:7]
    output io_enq_ready : UInt<1> @[src/main/scala/chisel3/util/Decoupled.scala 255:14]
    input io_enq_valid : UInt<1> @[src/main/scala/chisel3/util/Decoupled.scala 255:14]
    input io_enq_bits : UInt<128> @[src/main/scala/chisel3/util/Decoupled.scala 255:14]
    input io_deq_ready : UInt<1> @[src/main/scala/chisel3/util/Decoupled.scala 255:14]
    output io_deq_valid : UInt<1> @[src/main/scala/chisel3/util/Decoupled.scala 255:14]
    output io_deq_bits : UInt<128> @[src/main/scala/chisel3/util/Decoupled.scala 255:14]
    output io_count : UInt<3> @[src/main/scala/chisel3/util/Decoupled.scala 255:14]

    mem ram : @[src/main/scala/chisel3/util/Decoupled.scala 256:91]
      data-type => UInt<128>
      depth => 4
      read-latency => 0
      write-latency => 1
      reader => io_deq_bits_MPORT
      writer => MPORT
      read-under-write => undefined
    reg enq_ptr_value : UInt<2>, clock with :
      reset => (UInt<1>("h0"), enq_ptr_value) @[src/main/scala/chisel3/util/Counter.scala 61:40]
    reg deq_ptr_value : UInt<2>, clock with :
      reset => (UInt<1>("h0"), deq_ptr_value) @[src/main/scala/chisel3/util/Counter.scala 61:40]
    reg maybe_full : UInt<1>, clock with :
      reset => (UInt<1>("h0"), maybe_full) @[src/main/scala/chisel3/util/Decoupled.scala 259:27]
    node ptr_match = eq(enq_ptr_value, deq_ptr_value) @[src/main/scala/chisel3/util/Decoupled.scala 260:33]
    node _empty_T = eq(maybe_full, UInt<1>("h0")) @[src/main/scala/chisel3/util/Decoupled.scala 261:28]
    node empty = and(ptr_match, _empty_T) @[src/main/scala/chisel3/util/Decoupled.scala 261:25]
    node full = and(ptr_match, maybe_full) @[src/main/scala/chisel3/util/Decoupled.scala 262:24]
    node _do_enq_T = and(io_enq_ready, io_enq_valid) @[src/main/scala/chisel3/util/Decoupled.scala 51:35]
    node _do_deq_T = and(io_deq_ready, io_deq_valid) @[src/main/scala/chisel3/util/Decoupled.scala 51:35]
    node wrap = eq(enq_ptr_value, UInt<2>("h3")) @[src/main/scala/chisel3/util/Counter.scala 73:24]
    node _value_T = add(enq_ptr_value, UInt<1>("h1")) @[src/main/scala/chisel3/util/Counter.scala 77:24]
    node _value_T_1 = tail(_value_T, 1) @[src/main/scala/chisel3/util/Counter.scala 77:24]
    node do_enq = _do_enq_T @[src/main/scala/chisel3/util/Decoupled.scala 263:{27,27}]
    node _GEN_0 = validif(do_enq, enq_ptr_value) @[src/main/scala/chisel3/util/Decoupled.scala 269:16 270:8]
    node _GEN_1 = validif(do_enq, clock) @[src/main/scala/chisel3/util/Decoupled.scala 269:16 270:8]
    node _GEN_2 = mux(do_enq, UInt<1>("h1"), UInt<1>("h0")) @[src/main/scala/chisel3/util/Decoupled.scala 269:16 270:8 256:91]
    node _GEN_3 = validif(do_enq, UInt<1>("h1")) @[src/main/scala/chisel3/util/Decoupled.scala 269:16 270:24]
    node _GEN_4 = validif(do_enq, io_enq_bits) @[src/main/scala/chisel3/util/Decoupled.scala 269:16 270:24]
    node _GEN_5 = mux(do_enq, _value_T_1, enq_ptr_value) @[src/main/scala/chisel3/util/Decoupled.scala 269:16 src/main/scala/chisel3/util/Counter.scala 77:15 61:40]
    node wrap_1 = eq(deq_ptr_value, UInt<2>("h3")) @[src/main/scala/chisel3/util/Counter.scala 73:24]
    node _value_T_2 = add(deq_ptr_value, UInt<1>("h1")) @[src/main/scala/chisel3/util/Counter.scala 77:24]
    node _value_T_3 = tail(_value_T_2, 1) @[src/main/scala/chisel3/util/Counter.scala 77:24]
    node do_deq = _do_deq_T @[src/main/scala/chisel3/util/Decoupled.scala 264:{27,27}]
    node _GEN_6 = mux(do_deq, _value_T_3, deq_ptr_value) @[src/main/scala/chisel3/util/Decoupled.scala 273:16 src/main/scala/chisel3/util/Counter.scala 77:15 61:40]
    node _T = neq(do_enq, do_deq) @[src/main/scala/chisel3/util/Decoupled.scala 276:15]
    node _GEN_7 = mux(_T, do_enq, maybe_full) @[src/main/scala/chisel3/util/Decoupled.scala 276:27 277:16 259:27]
    node _GEN_8 = mux(UInt<1>("h0"), UInt<1>("h0"), _GEN_5) @[src/main/scala/chisel3/util/Decoupled.scala 279:15 src/main/scala/chisel3/util/Counter.scala 98:11]
    node _GEN_9 = mux(UInt<1>("h0"), UInt<1>("h0"), _GEN_6) @[src/main/scala/chisel3/util/Decoupled.scala 279:15 src/main/scala/chisel3/util/Counter.scala 98:11]
    node _GEN_10 = mux(UInt<1>("h0"), UInt<1>("h0"), _GEN_7) @[src/main/scala/chisel3/util/Decoupled.scala 279:15 282:16]
    node _io_deq_valid_T = eq(empty, UInt<1>("h0")) @[src/main/scala/chisel3/util/Decoupled.scala 285:19]
    node _io_enq_ready_T = eq(full, UInt<1>("h0")) @[src/main/scala/chisel3/util/Decoupled.scala 286:19]
    node _ptr_diff_T = sub(enq_ptr_value, deq_ptr_value) @[src/main/scala/chisel3/util/Decoupled.scala 309:32]
    node ptr_diff = tail(_ptr_diff_T, 1) @[src/main/scala/chisel3/util/Decoupled.scala 309:32]
    node _io_count_T = and(maybe_full, ptr_match) @[src/main/scala/chisel3/util/Decoupled.scala 312:32]
    node _io_count_T_1 = mux(_io_count_T, UInt<3>("h4"), UInt<1>("h0")) @[src/main/scala/chisel3/util/Decoupled.scala 312:20]
    node _io_count_T_2 = or(_io_count_T_1, ptr_diff) @[src/main/scala/chisel3/util/Decoupled.scala 312:62]
    io_enq_ready <= _io_enq_ready_T @[src/main/scala/chisel3/util/Decoupled.scala 286:16]
    io_deq_valid <= _io_deq_valid_T @[src/main/scala/chisel3/util/Decoupled.scala 285:16]
    io_deq_bits <= ram.io_deq_bits_MPORT.data @[src/main/scala/chisel3/util/Decoupled.scala 293:17]
    io_count <= _io_count_T_2 @[src/main/scala/chisel3/util/Decoupled.scala 312:14]
    ram.io_deq_bits_MPORT.addr <= deq_ptr_value @[src/main/scala/chisel3/util/Decoupled.scala 293:23]
    ram.io_deq_bits_MPORT.en <= UInt<1>("h1") @[src/main/scala/chisel3/util/Decoupled.scala 293:23]
    ram.io_deq_bits_MPORT.clk <= clock @[src/main/scala/chisel3/util/Decoupled.scala 293:23]
    ram.MPORT.addr <= _GEN_0
    ram.MPORT.en <= _GEN_2
    ram.MPORT.clk <= _GEN_1
    ram.MPORT.data <= _GEN_4
    ram.MPORT.mask <= _GEN_3
    enq_ptr_value <= mux(reset, UInt<2>("h0"), _GEN_8) @[src/main/scala/chisel3/util/Counter.scala 61:{40,40}]
    deq_ptr_value <= mux(reset, UInt<2>("h0"), _GEN_9) @[src/main/scala/chisel3/util/Counter.scala 61:{40,40}]
    maybe_full <= mux(reset, UInt<1>("h0"), _GEN_10) @[src/main/scala/chisel3/util/Decoupled.scala 259:{27,27}]

  module Queue32_UInt128 : @[src/main/scala/chisel3/util/Decoupled.scala 243:7]
    input clock : Clock @[src/main/scala/chisel3/util/Decoupled.scala 243:7]
    input reset : UInt<1> @[src/main/scala/chisel3/util/Decoupled.scala 243:7]
    output io_enq_ready : UInt<1> @[src/main/scala/chisel3/util/Decoupled.scala 255:14]
    input io_enq_valid : UInt<1> @[src/main/scala/chisel3/util/Decoupled.scala 255:14]
    input io_enq_bits : UInt<128> @[src/main/scala/chisel3/util/Decoupled.scala 255:14]
    input io_deq_ready : UInt<1> @[src/main/scala/chisel3/util/Decoupled.scala 255:14]
    output io_deq_valid : UInt<1> @[src/main/scala/chisel3/util/Decoupled.scala 255:14]
    output io_deq_bits : UInt<128> @[src/main/scala/chisel3/util/Decoupled.scala 255:14]
    output io_count : UInt<6> @[src/main/scala/chisel3/util/Decoupled.scala 255:14]

    mem ram : @[src/main/scala/chisel3/util/Decoupled.scala 256:91]
      data-type => UInt<128>
      depth => 32
      read-latency => 0
      write-latency => 1
      reader => io_deq_bits_MPORT
      writer => MPORT
      read-under-write => undefined
    reg enq_ptr_value : UInt<5>, clock with :
      reset => (UInt<1>("h0"), enq_ptr_value) @[src/main/scala/chisel3/util/Counter.scala 61:40]
    reg deq_ptr_value : UInt<5>, clock with :
      reset => (UInt<1>("h0"), deq_ptr_value) @[src/main/scala/chisel3/util/Counter.scala 61:40]
    reg maybe_full : UInt<1>, clock with :
      reset => (UInt<1>("h0"), maybe_full) @[src/main/scala/chisel3/util/Decoupled.scala 259:27]
    node ptr_match = eq(enq_ptr_value, deq_ptr_value) @[src/main/scala/chisel3/util/Decoupled.scala 260:33]
    node _empty_T = eq(maybe_full, UInt<1>("h0")) @[src/main/scala/chisel3/util/Decoupled.scala 261:28]
    node empty = and(ptr_match, _empty_T) @[src/main/scala/chisel3/util/Decoupled.scala 261:25]
    node full = and(ptr_match, maybe_full) @[src/main/scala/chisel3/util/Decoupled.scala 262:24]
    node _do_enq_T = and(io_enq_ready, io_enq_valid) @[src/main/scala/chisel3/util/Decoupled.scala 51:35]
    node _do_deq_T = and(io_deq_ready, io_deq_valid) @[src/main/scala/chisel3/util/Decoupled.scala 51:35]
    node wrap = eq(enq_ptr_value, UInt<5>("h1f")) @[src/main/scala/chisel3/util/Counter.scala 73:24]
    node _value_T = add(enq_ptr_value, UInt<1>("h1")) @[src/main/scala/chisel3/util/Counter.scala 77:24]
    node _value_T_1 = tail(_value_T, 1) @[src/main/scala/chisel3/util/Counter.scala 77:24]
    node do_enq = _do_enq_T @[src/main/scala/chisel3/util/Decoupled.scala 263:{27,27}]
    node _GEN_0 = validif(do_enq, enq_ptr_value) @[src/main/scala/chisel3/util/Decoupled.scala 269:16 270:8]
    node _GEN_1 = validif(do_enq, clock) @[src/main/scala/chisel3/util/Decoupled.scala 269:16 270:8]
    node _GEN_2 = mux(do_enq, UInt<1>("h1"), UInt<1>("h0")) @[src/main/scala/chisel3/util/Decoupled.scala 269:16 270:8 256:91]
    node _GEN_3 = validif(do_enq, UInt<1>("h1")) @[src/main/scala/chisel3/util/Decoupled.scala 269:16 270:24]
    node _GEN_4 = validif(do_enq, io_enq_bits) @[src/main/scala/chisel3/util/Decoupled.scala 269:16 270:24]
    node _GEN_5 = mux(do_enq, _value_T_1, enq_ptr_value) @[src/main/scala/chisel3/util/Decoupled.scala 269:16 src/main/scala/chisel3/util/Counter.scala 77:15 61:40]
    node wrap_1 = eq(deq_ptr_value, UInt<5>("h1f")) @[src/main/scala/chisel3/util/Counter.scala 73:24]
    node _value_T_2 = add(deq_ptr_value, UInt<1>("h1")) @[src/main/scala/chisel3/util/Counter.scala 77:24]
    node _value_T_3 = tail(_value_T_2, 1) @[src/main/scala/chisel3/util/Counter.scala 77:24]
    node do_deq = _do_deq_T @[src/main/scala/chisel3/util/Decoupled.scala 264:{27,27}]
    node _GEN_6 = mux(do_deq, _value_T_3, deq_ptr_value) @[src/main/scala/chisel3/util/Decoupled.scala 273:16 src/main/scala/chisel3/util/Counter.scala 77:15 61:40]
    node _T = neq(do_enq, do_deq) @[src/main/scala/chisel3/util/Decoupled.scala 276:15]
    node _GEN_7 = mux(_T, do_enq, maybe_full) @[src/main/scala/chisel3/util/Decoupled.scala 276:27 277:16 259:27]
    node _GEN_8 = mux(UInt<1>("h0"), UInt<1>("h0"), _GEN_5) @[src/main/scala/chisel3/util/Decoupled.scala 279:15 src/main/scala/chisel3/util/Counter.scala 98:11]
    node _GEN_9 = mux(UInt<1>("h0"), UInt<1>("h0"), _GEN_6) @[src/main/scala/chisel3/util/Decoupled.scala 279:15 src/main/scala/chisel3/util/Counter.scala 98:11]
    node _GEN_10 = mux(UInt<1>("h0"), UInt<1>("h0"), _GEN_7) @[src/main/scala/chisel3/util/Decoupled.scala 279:15 282:16]
    node _io_deq_valid_T = eq(empty, UInt<1>("h0")) @[src/main/scala/chisel3/util/Decoupled.scala 285:19]
    node _io_enq_ready_T = eq(full, UInt<1>("h0")) @[src/main/scala/chisel3/util/Decoupled.scala 286:19]
    node _ptr_diff_T = sub(enq_ptr_value, deq_ptr_value) @[src/main/scala/chisel3/util/Decoupled.scala 309:32]
    node ptr_diff = tail(_ptr_diff_T, 1) @[src/main/scala/chisel3/util/Decoupled.scala 309:32]
    node _io_count_T = and(maybe_full, ptr_match) @[src/main/scala/chisel3/util/Decoupled.scala 312:32]
    node _io_count_T_1 = mux(_io_count_T, UInt<6>("h20"), UInt<1>("h0")) @[src/main/scala/chisel3/util/Decoupled.scala 312:20]
    node _io_count_T_2 = or(_io_count_T_1, ptr_diff) @[src/main/scala/chisel3/util/Decoupled.scala 312:62]
    io_enq_ready <= _io_enq_ready_T @[src/main/scala/chisel3/util/Decoupled.scala 286:16]
    io_deq_valid <= _io_deq_valid_T @[src/main/scala/chisel3/util/Decoupled.scala 285:16]
    io_deq_bits <= ram.io_deq_bits_MPORT.data @[src/main/scala/chisel3/util/Decoupled.scala 293:17]
    io_count <= _io_count_T_2 @[src/main/scala/chisel3/util/Decoupled.scala 312:14]
    ram.io_deq_bits_MPORT.addr <= deq_ptr_value @[src/main/scala/chisel3/util/Decoupled.scala 293:23]
    ram.io_deq_bits_MPORT.en <= UInt<1>("h1") @[src/main/scala/chisel3/util/Decoupled.scala 293:23]
    ram.io_deq_bits_MPORT.clk <= clock @[src/main/scala/chisel3/util/Decoupled.scala 293:23]
    ram.MPORT.addr <= _GEN_0
    ram.MPORT.en <= _GEN_2
    ram.MPORT.clk <= _GEN_1
    ram.MPORT.data <= _GEN_4
    ram.MPORT.mask <= _GEN_3
    enq_ptr_value <= mux(reset, UInt<5>("h0"), _GEN_8) @[src/main/scala/chisel3/util/Counter.scala 61:{40,40}]
    deq_ptr_value <= mux(reset, UInt<5>("h0"), _GEN_9) @[src/main/scala/chisel3/util/Counter.scala 61:{40,40}]
    maybe_full <= mux(reset, UInt<1>("h0"), _GEN_10) @[src/main/scala/chisel3/util/Decoupled.scala 259:{27,27}]

  module SidebandEnqArbiter : @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 115:7]
    input clock : Clock @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 115:7]
    input reset : UInt<1> @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 115:7]
    input io_out_0_ready : UInt<1> @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 116:14]
    output io_out_0_valid : UInt<1> @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 116:14]
    output io_out_0_bits : UInt<128> @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 116:14]
    input io_out_1_ready : UInt<1> @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 116:14]
    output io_out_1_valid : UInt<1> @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 116:14]
    output io_out_1_bits : UInt<128> @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 116:14]
    input io_out_2_ready : UInt<1> @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 116:14]
    output io_out_2_valid : UInt<1> @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 116:14]
    output io_out_2_bits : UInt<128> @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 116:14]
    output io_in_ready : UInt<1> @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 116:14]
    input io_in_valid : UInt<1> @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 116:14]
    input io_in_bits : UInt<128> @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 116:14]

    node _io_out_0_valid_T = and(io_in_bits, UInt<5>("h1f")) @[generators/uciedigital/src/main/scala/sideband/sb-msg-encoding.scala 389:31]
    node _io_out_0_valid_T_1 = eq(UInt<5>("h10"), _io_out_0_valid_T) @[generators/uciedigital/src/main/scala/sideband/sb-msg-encoding.scala 389:31]
    node _io_out_0_valid_T_2 = and(io_in_bits, UInt<5>("h1f")) @[generators/uciedigital/src/main/scala/sideband/sb-msg-encoding.scala 389:46]
    node _io_out_0_valid_T_3 = eq(UInt<5>("h11"), _io_out_0_valid_T_2) @[generators/uciedigital/src/main/scala/sideband/sb-msg-encoding.scala 389:46]
    node _io_out_0_valid_T_4 = or(_io_out_0_valid_T_1, _io_out_0_valid_T_3) @[generators/uciedigital/src/main/scala/sideband/sb-msg-encoding.scala 389:42]
    node _io_out_0_valid_T_5 = and(io_in_bits, UInt<5>("h1f")) @[generators/uciedigital/src/main/scala/sideband/sb-msg-encoding.scala 389:62]
    node _io_out_0_valid_T_6 = eq(UInt<5>("h19"), _io_out_0_valid_T_5) @[generators/uciedigital/src/main/scala/sideband/sb-msg-encoding.scala 389:62]
    node _io_out_0_valid_T_7 = or(_io_out_0_valid_T_4, _io_out_0_valid_T_6) @[generators/uciedigital/src/main/scala/sideband/sb-msg-encoding.scala 389:58]
    node _io_out_0_valid_T_8 = and(io_in_valid, _io_out_0_valid_T_7) @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 126:34]
    node _io_out_1_valid_T = and(io_in_bits, UInt<5>("h1f")) @[generators/uciedigital/src/main/scala/sideband/sb-msg-encoding.scala 390:30]
    node _io_out_1_valid_T_1 = eq(UInt<5>("h12"), _io_out_1_valid_T) @[generators/uciedigital/src/main/scala/sideband/sb-msg-encoding.scala 390:30]
    node _io_out_1_valid_T_2 = and(io_in_bits, UInt<5>("h1f")) @[generators/uciedigital/src/main/scala/sideband/sb-msg-encoding.scala 390:44]
    node _io_out_1_valid_T_3 = eq(UInt<5>("h1b"), _io_out_1_valid_T_2) @[generators/uciedigital/src/main/scala/sideband/sb-msg-encoding.scala 390:44]
    node _io_out_1_valid_T_4 = or(_io_out_1_valid_T_1, _io_out_1_valid_T_3) @[generators/uciedigital/src/main/scala/sideband/sb-msg-encoding.scala 390:40]
    node _io_out_1_valid_T_5 = and(io_in_valid, _io_out_1_valid_T_4) @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 127:34]
    node _io_out_2_valid_T = bits(io_in_bits, 4, 4) @[generators/uciedigital/src/main/scala/sideband/sb-msg-encoding.scala 391:30]
    node _io_out_2_valid_T_1 = not(_io_out_2_valid_T) @[generators/uciedigital/src/main/scala/sideband/sb-msg-encoding.scala 391:28]
    node _io_out_2_valid_T_2 = and(io_in_valid, _io_out_2_valid_T_1) @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 128:34]
    io_out_0_valid <= _io_out_0_valid_T_8 @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 126:19]
    io_out_0_bits <= io_in_bits @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 121:38]
    io_out_1_valid <= _io_out_1_valid_T_5 @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 127:19]
    io_out_1_bits <= io_in_bits @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 121:38]
    io_out_2_valid <= _io_out_2_valid_T_2 @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 128:19]
    io_out_2_bits <= io_in_bits @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 121:38]
    io_in_ready <= UInt<1>("h1") @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 125:15]

  module SidebandDeqArbiter : @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 131:7]
    input clock : Clock @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 131:7]
    input reset : UInt<1> @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 131:7]
    input io_out_ready : UInt<1> @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 132:14]
    output io_out_valid : UInt<1> @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 132:14]
    output io_out_bits : UInt<128> @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 132:14]
    output io_in_0_ready : UInt<1> @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 132:14]
    input io_in_0_valid : UInt<1> @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 132:14]
    input io_in_0_bits : UInt<128> @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 132:14]
    output io_in_1_ready : UInt<1> @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 132:14]
    input io_in_1_valid : UInt<1> @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 132:14]
    input io_in_1_bits : UInt<128> @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 132:14]
    output io_in_2_ready : UInt<1> @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 132:14]
    input io_in_2_valid : UInt<1> @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 132:14]
    input io_in_2_bits : UInt<128> @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 132:14]

    node _io_out_valid_T = or(io_in_0_valid, io_in_1_valid) @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 137:34]
    node _io_out_valid_T_1 = or(_io_out_valid_T, io_in_2_valid) @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 137:52]
    node _GEN_0 = mux(io_in_2_valid, UInt<1>("h0"), UInt<1>("h0")) @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 149:30 151:22 155:40]
    node _GEN_1 = mux(io_in_2_valid, io_out_ready, UInt<1>("h0")) @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 149:30 151:22 155:40]
    node _GEN_2 = mux(io_in_2_valid, io_in_2_bits, io_in_0_bits) @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 149:30 153:17 156:17]
    node _GEN_3 = mux(io_in_1_valid, UInt<1>("h0"), _GEN_0) @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 144:30 146:22]
    node _GEN_4 = mux(io_in_1_valid, io_out_ready, _GEN_0) @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 144:30 146:22]
    node _GEN_5 = mux(io_in_1_valid, UInt<1>("h0"), _GEN_1) @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 144:30 146:22]
    node _GEN_6 = mux(io_in_1_valid, io_in_1_bits, _GEN_2) @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 144:30 148:17]
    node _GEN_7 = mux(io_in_0_valid, io_out_ready, _GEN_3) @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 139:24 141:22]
    node _GEN_8 = mux(io_in_0_valid, UInt<1>("h0"), _GEN_4) @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 139:24 141:22]
    node _GEN_9 = mux(io_in_0_valid, UInt<1>("h0"), _GEN_5) @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 139:24 141:22]
    node _GEN_10 = mux(io_in_0_valid, io_in_0_bits, _GEN_6) @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 139:24 143:17]
    io_out_valid <= _io_out_valid_T_1 @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 137:16]
    io_out_bits <= _GEN_10
    io_in_0_ready <= _GEN_7
    io_in_1_ready <= _GEN_8
    io_in_2_ready <= _GEN_9

  module SidebandPriorityQueue : @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 85:7]
    input clock : Clock @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 85:7]
    input reset : UInt<1> @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 85:7]
    output io_enq_ready : UInt<1> @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 86:14]
    input io_enq_valid : UInt<1> @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 86:14]
    input io_enq_bits : UInt<128> @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 86:14]
    input io_deq_ready : UInt<1> @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 86:14]
    output io_deq_valid : UInt<1> @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 86:14]
    output io_deq_bits : UInt<128> @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 86:14]

    inst p0_queue of Queue4_UInt128 @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 91:24]
    inst p1_queue of Queue32_UInt128 @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 94:24]
    inst p2_queue of Queue32_UInt128 @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 97:24]
    inst enq_arb of SidebandEnqArbiter @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 101:23]
    inst deq_arb of SidebandDeqArbiter @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 102:23]
    io_enq_ready <= enq_arb.io_in_ready @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 104:17]
    io_deq_valid <= deq_arb.io_out_valid @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 112:18]
    io_deq_bits <= deq_arb.io_out_bits @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 112:18]
    p0_queue.clock <= clock
    p0_queue.reset <= reset
    p0_queue.io_enq_valid <= enq_arb.io_out_0_valid @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 105:21]
    p0_queue.io_enq_bits <= enq_arb.io_out_0_bits @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 105:21]
    p0_queue.io_deq_ready <= deq_arb.io_in_0_ready @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 109:20]
    p1_queue.clock <= clock
    p1_queue.reset <= reset
    p1_queue.io_enq_valid <= enq_arb.io_out_1_valid @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 106:21]
    p1_queue.io_enq_bits <= enq_arb.io_out_1_bits @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 106:21]
    p1_queue.io_deq_ready <= deq_arb.io_in_1_ready @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 110:20]
    p2_queue.clock <= clock
    p2_queue.reset <= reset
    p2_queue.io_enq_valid <= enq_arb.io_out_2_valid @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 107:21]
    p2_queue.io_enq_bits <= enq_arb.io_out_2_bits @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 107:21]
    p2_queue.io_deq_ready <= deq_arb.io_in_2_ready @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 111:20]
    enq_arb.clock <= clock
    enq_arb.reset <= reset
    enq_arb.io_out_0_ready <= p0_queue.io_enq_ready @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 105:21]
    enq_arb.io_out_1_ready <= p1_queue.io_enq_ready @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 106:21]
    enq_arb.io_out_2_ready <= p2_queue.io_enq_ready @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 107:21]
    enq_arb.io_in_valid <= io_enq_valid @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 104:17]
    enq_arb.io_in_bits <= io_enq_bits @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 104:17]
    deq_arb.clock <= clock
    deq_arb.reset <= reset
    deq_arb.io_out_ready <= io_deq_ready @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 112:18]
    deq_arb.io_in_0_valid <= p0_queue.io_deq_valid @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 109:20]
    deq_arb.io_in_0_bits <= p0_queue.io_deq_bits @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 109:20]
    deq_arb.io_in_1_valid <= p1_queue.io_deq_valid @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 110:20]
    deq_arb.io_in_1_bits <= p1_queue.io_deq_bits @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 110:20]
    deq_arb.io_in_2_valid <= p2_queue.io_deq_valid @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 111:20]
    deq_arb.io_in_2_bits <= p2_queue.io_deq_bits @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 111:20]
