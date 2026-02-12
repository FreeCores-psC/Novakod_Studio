############################################################################
# Based constraints for gencore
############################################################################

## Clock
create_clock -period 20 -name clk [get_ports {clk}]
set_input_jitter [get_clocks {clk}] 0.25

