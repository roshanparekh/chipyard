FIRRTL version 1.2.0
circuit SidebandLinkDeserializer :
  extmodule SBDeserializerBlackBox : @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 350:7]
    input clk : Clock
    input rst : AsyncReset
    input in_data : UInt<1>
    output out_data : UInt<128>
    output out_data_valid : UInt<1>
    defname = SBDeserializerBlackBox
    parameter WIDTH = 128
    parameter WIDTH_W = 8

  module SidebandLinkDeserializer : @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 309:7]
    input clock : Clock @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 309:7]
    input reset : UInt<1> @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 309:7]
    input io_in_bits : UInt<1> @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 315:14]
    input io_in_remote_clock : UInt<1> @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 315:14]
    input io_out_ready : UInt<1> @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 315:14]
    output io_out_valid : UInt<1> @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 315:14]
    output io_out_bits : UInt<128> @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 315:14]

    inst sbDeserBlackBox of SBDeserializerBlackBox @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 327:31]
    node remote_clock = asClock(io_in_remote_clock) @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 323:41]
    reg valid_sync_1 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), valid_sync_1) @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 329:29]
    reg valid_sync : UInt<1>, clock with :
      reset => (UInt<1>("h0"), valid_sync) @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 330:27]
    reg data_sync_1 : UInt<128>, clock with :
      reset => (UInt<1>("h0"), data_sync_1) @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 331:28]
    reg data_sync : UInt<128>, clock with :
      reset => (UInt<1>("h0"), data_sync) @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 332:26]
    reg flag : UInt<1>, clock with :
      reset => (UInt<1>("h0"), flag) @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 334:21]
    node _GEN_0 = mux(valid_sync, UInt<1>("h0"), UInt<1>("h1")) @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 335:20 336:10 338:10]
    node _io_out_valid_T = and(valid_sync, flag) @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 341:30]
    node _sbDeserBlackBox_io_rst_T = asAsyncReset(reset) @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 345:35]
    io_out_valid <= _io_out_valid_T @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 341:16]
    io_out_bits <= data_sync @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 342:15]
    sbDeserBlackBox.clk <= remote_clock @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 344:26]
    sbDeserBlackBox.rst <= _sbDeserBlackBox_io_rst_T @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 345:26]
    sbDeserBlackBox.in_data <= io_in_bits @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 346:30]
    valid_sync_1 <= sbDeserBlackBox.out_data_valid @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 329:29]
    valid_sync <= valid_sync_1 @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 330:27]
    data_sync_1 <= sbDeserBlackBox.out_data @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 331:28]
    data_sync <= data_sync_1 @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 332:26]
    flag <= mux(reset, UInt<1>("h1"), _GEN_0) @[generators/uciedigital/src/main/scala/sideband/sidebandNode.scala 334:{21,21}]
