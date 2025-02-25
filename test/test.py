import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles
import random

#
# 1. Reference model in Python
#
def leading_one_detector_16bit(x: int) -> int:
    """Return the 'leading one' code that the hardware should output."""
    # If zero => 0xF0
    if x == 0:
        return 0xF0

    # Otherwise, find the highest-order '1' bit from the left in a 16-bit number.
    # Bit 15 is the MSB, bit 0 is the LSB, and output ranges from 15..0.
    for i in range(15, -1, -1):
        if (x & (1 << i)) != 0:
            return i
    # Fallback - should never happen
    return 0xF0


#
# 2. Common reset procedure
#
async def reset_dut(dut, cycles=5):
    """Drives reset_n low for a few clock cycles."""
    dut.rst_n.value = 0
    dut.ena.value = 1  # Typically 'ena' is just high
    await ClockCycles(dut.clk, cycles)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 1)


#
# 3. Main test: Directed + Random tests
#
@cocotb.test()
async def test_leading_one_detector(dut):
    """
    Exercises a variety of inputs on the tt_um_BRS module and checks
    that uo_out matches the expected 'leading-one' position code.
    """

    # Create a clock on dut.clk. 
    # 10 us period => 100 kHz (just an arbitrary slow clock for demonstration)
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Reset the DUT
    await reset_dut(dut)

    #
    # 3.1 Directed tests for known patterns
    #
    test_vectors = [
        (0x0000, 0xF0),  # All zero => 0xF0
        (0x8000, 15),
        (0x4000, 14),
        (0x2000, 13),
        (0x1000, 12),
        (0x0800, 11),
        (0x0400, 10),
        (0x0200, 9),
        (0x0100, 8),
        (0x0080, 7),
        (0x0040, 6),
        (0x0020, 5),
        (0x0010, 4),
        (0x0008, 3),
        (0x0004, 2),
        (0x0002, 1),
        (0x0001, 0),
        (0xABCD, leading_one_detector_16bit(0xABCD)),
        (0x1234, leading_one_detector_16bit(0x1234)),
        (0xF000, leading_one_detector_16bit(0xF000)),
    ]

    for input_val, expected_val in test_vectors:
        # Split into ui_in (top 8 bits) and uio_in (bottom 8 bits)
        dut.ui_in.value = (input_val >> 8) & 0xFF
        dut.uio_in.value = input_val & 0xFF

        # Wait 1 clock for combinational propagation (or more, if desired)
        await ClockCycles(dut.clk, 1)

        observed_val = dut.uo_out.value.integer
        dut._log.info(f"Input=0x{input_val:04X}, Expected={expected_val}, Got={observed_val}")
        assert observed_val == expected_val, \
            f"FAIL: For 0x{input_val:04X}, expected {expected_val}, got {observed_val}"


    #
    # 3.2 Random tests
    #
    RANDOM_TESTS = 20
    for _ in range(RANDOM_TESTS):
        input_val = random.randint(0, 0xFFFF)
        dut.ui_in.value = (input_val >> 8) & 0xFF
        dut.uio_in.value = input_val & 0xFF

        await ClockCycles(dut.clk, 1)

        expected_val = leading_one_detector_16bit(input_val)
        observed_val = dut.uo_out.value.integer

        dut._log.debug(f"RANDOM TEST: In=0x{input_val:04X}, Exp={expected_val}, Got={observed_val}")
        assert observed_val == expected_val, \
            f"Random test failed for input=0x{input_val:04X}: expected {expected_val}, got {observed_val}"


    dut._log.info("All tests passed successfully!")
