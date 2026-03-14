# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles
import numpy as np
# import matplotlib.pyplot as plt

@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    y = np.zeros(10000)

    dut._log.info("Test project behavior")
    for t in range(10000):
        x = round(2**15*np.sin(t/1000))
        dut.ui_in.value = x // 256 # MSBs x >> 8
        dut.uio_in.value = x % 256 # LSBs x & 255
        await ClockCycles(dut.clk, 1)
        y[t] = dut.uo_out.value[0]

    # plt.psd(y-0.5, Fs = 48e3*128)
    # plt.show()
    

    # Keep testing the module by changing the input values, waiting for
    # one or more clock cycles, and asserting the expected output values.
