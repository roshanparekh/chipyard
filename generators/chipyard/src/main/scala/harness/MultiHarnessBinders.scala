package chipyard.harness

import chisel3._
import chisel3.util._

import org.chipsalliance.cde.config.{Field, Config, Parameters}
import freechips.rocketchip.diplomacy.{LazyModule, LazyModuleImpLike}
import freechips.rocketchip.devices.debug._
import freechips.rocketchip.subsystem._
import freechips.rocketchip.util._

import testchipip.serdes._

import chipyard._
import chipyard.iobinders.{GetSystemParameters, JTAGChipIO, HasChipyardPorts, Port, SerialTLPort, UciephyTestPort}

import scala.reflect.{ClassTag}

case class MultiHarnessBinders(chip0: Int, chip1: Int) extends Field[Seq[MultiHarnessBinderFunction]](Nil)

object ApplyMultiHarnessBinders {
  def apply(th: HasHarnessInstantiators, chips: Seq[LazyModule])(implicit p: Parameters): Unit = {
    Seq.tabulate(chips.size, chips.size) { case (i, j) => if (i != j) {
      (chips(i), chips(j)) match {
        case (l0: HasChipyardPorts, l1: HasChipyardPorts) => p(MultiHarnessBinders(i, j)).foreach { f =>
          f(th, l0.ports, l1.ports)
        }
      }
    }}
  }
}

class MultiHarnessBinder[T <: Port[_], U <: Port[_], S <: HasHarnessInstantiators](
  chip0: Int, chip1: Int,
  chip0portFn: T => Boolean, chip1portFn: U => Boolean,
  connectFn: (S, T, U) => Unit
)(implicit tag0: ClassTag[T], tag1: ClassTag[U], tag2: ClassTag[S]) extends Config((site, here, up) => {
    // Override any HarnessBinders for chip0/chip1
    case MultiChipParameters(`chip0`) => new Config(
      new HarnessBinder({case (th: S, port: T, chipId: Int) if chip0portFn(port) => }) ++ up(MultiChipParameters(chip0))
    )
    case MultiChipParameters(`chip1`) => new Config(
      new HarnessBinder({case (th: S, port: U, chipId: Int) if chip1portFn(port) => }) ++ up(MultiChipParameters(chip1))
    )
    // Set the multiharnessbinder key
    case MultiHarnessBinders(`chip0`, `chip1`) => up(MultiHarnessBinders(chip0, chip1)) :+ {
      ((th: S, chip0Ports: Seq[Port[_]], chip1Ports: Seq[Port[_]]) => {
        val chip0Port: Seq[T] = chip0Ports.collect { case (p: T) if chip0portFn(p) => p }
        val chip1Port: Seq[U] = chip1Ports.collect { case (p: U) if chip1portFn(p) => p }
        require(chip0Port.size == 1 && chip1Port.size == 1)
        connectFn(th, chip0Port(0), chip1Port(0))
      })
    }
  })

class WithMultiChipSerialTL(chip0: Int, chip1: Int, chip0portId: Int = 0, chip1portId: Int = 0) extends MultiHarnessBinder(
  chip0, chip1,
  (p0: SerialTLPort) => p0.portId == chip0portId,
  (p1: SerialTLPort) => p1.portId == chip1portId,
  (th: HasHarnessInstantiators, p0: SerialTLPort, p1: SerialTLPort) => {
    def connectDecoupledSyncPhitIO(clkSource: DecoupledInternalSyncPhitIO, clkSink: DecoupledExternalSyncPhitIO) = {
      clkSink.clock_in := clkSource.clock_out
      clkSink.in <> clkSource.out
      clkSource.in <> clkSink.out
    }
    def connectSourceSyncPhitIO(a: CreditedSourceSyncPhitIO, b: CreditedSourceSyncPhitIO) = {
      a.clock_in := b.clock_out
      b.clock_in := a.clock_out
      a.reset_in := b.reset_out
      b.reset_in := a.reset_out
      a.in := b.out
      b.in := a.out
    }
    (p0.io, p1.io) match {
      case (io0: DecoupledInternalSyncPhitIO, io1: DecoupledExternalSyncPhitIO) => connectDecoupledSyncPhitIO(io0, io1)
      case (io0: DecoupledExternalSyncPhitIO, io1: DecoupledInternalSyncPhitIO) => connectDecoupledSyncPhitIO(io1, io0)
      case (io0: CreditedSourceSyncPhitIO   , io1: CreditedSourceSyncPhitIO   ) => connectSourceSyncPhitIO   (io0, io1)
    }
  }
)


class WithMultiChipUciephyTest(chip0: Int, chip1: Int) extends MultiHarnessBinder(
  chip0, chip1,
  (p0: UciephyTestPort) => true,
  (p1: UciephyTestPort) => true,
  (th: HasHarnessInstantiators, p0: UciephyTestPort, p1: UciephyTestPort) => {
    (p0.io, p1.io) match {
      case(io0: uciephytest.UciephyTestTLIO, io1: uciephytest.UciephyTestTLIO) => {
        io0.common.phy.refClkP      := th.harnessBinderClock.asBool
        io0.common.phy.refClkN      := (!th.harnessBinderClock.asBool)
        io0.common.phy.bypassClkP   := th.harnessBinderClock.asBool
        io0.common.phy.bypassClkN   := (!th.harnessBinderClock.asBool)
        io0.common.phy.pllRdacVref  := true.B

        io1.common.phy.refClkP      := th.harnessBinderClock.asBool
        io1.common.phy.refClkN      := (!th.harnessBinderClock.asBool)
        io1.common.phy.bypassClkP   := th.harnessBinderClock.asBool
        io1.common.phy.bypassClkN   := (!th.harnessBinderClock.asBool)
        io1.common.phy.pllRdacVref  := true.B
        
        io0.phy.rxClkP    := io1.phy.txClkP
        io0.phy.rxClkN    := io1.phy.txClkN
        io0.phy.rxValid   := io1.phy.txValid
        io0.phy.rxTrack   := io1.phy.txTrack
        io0.phy.rxData    := io1.phy.txData
        io0.phy.sbRxClk   := io1.phy.sbTxClk
        io0.phy.sbRxData  := io1.phy.sbTxData

        io1.phy.rxClkP    := io0.phy.txClkP
        io1.phy.rxClkN    := io0.phy.txClkN
        io1.phy.rxValid   := io0.phy.txValid
        io1.phy.rxTrack   := io0.phy.txTrack
        io1.phy.rxData    := io0.phy.txData
        io1.phy.sbRxClk   := io0.phy.sbTxClk
        io1.phy.sbRxData  := io0.phy.sbTxData
      }
    }
  }
)