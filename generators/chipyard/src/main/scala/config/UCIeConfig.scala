package chipyard

import chisel3._
import chisel3.util._
import org.chipsalliance.cde.config.{Config, Parameters}
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.rocket._
import freechips.rocketchip.subsystem._
import testchipip.soc.{OBUS}
import chipyard.harness.BuildTop
import chipyard.iobinders._
import sifive.blocks.devices.uart._
import testchipip._
import testchipip.boot._
import scala.collection.immutable.ListMap
import constellation.channel._
import constellation.routing._
import constellation.router._
import constellation.topology._
import constellation.noc._
import constellation.soc.{GlobalNoCParams}
import shuttle.common._
import saturn.common.{VectorParams}
import freechips.rocketchip.util.{AsyncQueueParams}
import freechips.rocketchip.subsystem.WithoutTLMonitors
import edu.berkeley.cs.ucie.digital.tilelink._

class UCIePhyRocketConfig extends Config (
  new testchipip.soc.WithChipIdPin ++          // Add pin to identify chips

  new uciephytest.WithUciephyTest(Seq(uciephytest.UciephyTestParams(address=0x20000,
                                                                numLanes = 16,
                                                                tlParams = TileLinkParams(address = 0x100000000L,
                                                                addressRange = (1L << 32) - 1,
                                                                configAddress = 0x8000,
                                                                inwardQueueDepth = 2,
                                                                outwardQueueDepth = 2,
                                                                dataWidth_arg = 256),
                                                                onchipAddr = Some(0x1000000000L),
                                                                sim = true))) ++

  new testchipip.soc.WithOffchipBusClient(SBUS,
    blockRange = Seq(AddressSet(0, (1L << 32) - 1)),
    replicationBase = Some(1L << 32) 
  ) ++
  new testchipip.soc.WithOffchipBus ++                                                
  new chipyard.iobinders.WithUCIePunchthrough ++
  new freechips.rocketchip.rocket.WithNHugeCores(1) ++
  new chipyard.config.AbstractConfig
)

/*
make CONFIG=UciephyTestLoopbackConfig -j16
*/
class UciephyTestLoopbackConfig extends Config (
  // new chipyard.harness.WithAbsoluteFreqHarnessClockInstantiator ++
  new chipyard.harness.WithUciephyTestLoopback ++
  new UCIePhyRocketConfig
)

/*
make CONFIG=MultiUciephyTestConfig -j16
*/
class MultiUciephyTestConfig extends Config (
  new chipyard.harness.WithAbsoluteFreqHarnessClockInstantiator ++
  new chipyard.harness.WithMultiChipUciephyTest(chip0=0, chip1=1) ++
  new chipyard.harness.WithMultiChip(0, new UCIePhyRocketConfig) ++
  new chipyard.harness.WithMultiChip(1, new UCIePhyRocketConfig)
)