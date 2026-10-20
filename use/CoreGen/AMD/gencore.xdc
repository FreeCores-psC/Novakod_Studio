############################################################################
# Based constraints for gencore
############################################################################

## Clock
create_clock -name clk -period 20.0 -waveform {0.0 10.0} [get_ports clk]
set_input_jitter [get_clocks {clk}] 0.25

create_clock -name memclk -period 20.0 -waveform {10.0 20.0} [get_ports memclk]
set_input_jitter [get_clocks {memclk}] 0.25

