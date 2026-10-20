# ---------------------------------------------------------------------------
# Ensure Implemented Design is Open in Memory
# ---------------------------------------------------------------------------
set design_open 0
if {![catch {set current_ds [current_design]}]} {
    if {$current_ds ne ""} {
        set design_open 1
    }
}

if {!$design_open} {
    puts "No open design found. Attempting to open implemented design (impl_1)..."
    if {[catch {open_run impl_1} err]} {
        puts "ERROR: Failed to open impl_1. Make sure implementation completed successfully: $err"
        return
    }
}

# -------------------------
# post_route_custom.tcl
# -------------------------
set target_period 20.0

# Define the list of internal clocks to target
set internal_clocks [get_clocks -filter {NAME =~ *clk* && NAME !~ *okHostClk*}]

# Query slack metrics strictly within the internal clock domains
set wns [get_property SLACK [get_timing_paths -max_paths 1 -setup -from $internal_clocks -to $internal_clocks]]
set whs [get_property SLACK [get_timing_paths -max_paths 1 -hold -from $internal_clocks -to $internal_clocks]]
set fmax [expr {1000.0 / ($target_period - $wns)}]

# -------------------------
# Save directly to disk
# -------------------------
set proj_dir [file normalize "[pwd]/../../"]
set NovakodReport [open "$proj_dir/NovakodReport.txt" w]
puts $NovakodReport "=================================================="
puts $NovakodReport "  FAST TIMING SUMMARY RESULTS"
puts $NovakodReport "--------------------------------------------------"
puts $NovakodReport "  Worst Negative Slack (Setup): ${wns} ns"
puts $NovakodReport "  Worst Hold Slack (Hold):      ${whs} ns"
puts $NovakodReport "  Max Frequency:               [format "%.2f" $fmax] MHz"

# ---- EXTRACT 5 WORST FAILING PATHS IF TIMING VIOLATED ----
puts $NovakodReport "\n=================================================="
puts $NovakodReport "  TOP 5 WORST FAILING TIMING PATHS"
puts $NovakodReport "--------------------------------------------------"

if { $wns < 0 } {

    set failing_paths [get_timing_paths -max_paths 5 -setup]
    set path_index 1

    foreach path $failing_paths {
        set slack [get_property SLACK $path]
        set src_pin [get_property STARTPOINT_PIN $path]
        set dst_pin [get_property ENDPOINT_PIN $path]

        puts $NovakodReport "\nPath #${path_index} | Slack: ${slack} ns"
        puts $NovakodReport "  Source (From): $src_pin"
        puts $NovakodReport "  Destination (To): $dst_pin"

        incr path_index
    }
    puts $NovakodReport {
How To Locate Timing Error On the schematic
--------------------------------------------------
    To show a specific timing path from a startpoint to an endpoint on a schematic in Vivado,
    generate a targeted timing report using -from and -to options, select the failing path result,
    and open it directly in the schematic viewer.

Steps to Display the Path on a Schematic:

    1. Start the Vivado project.
    2. Run the specific timing report in the Tcl Console using your exact start and end points:
           tclreport_timing -from [get_pins {path/to/start_reg/C}]
                            -to   [get_pins {path/to/end_reg/D}]
                            -name timing_path_custom
    3. Open the Timing Results window or look at the newly created table in the workspace under your custom report name.
    4. Click and select the failing path row.
    5. Press F4 on your keyboard or right-click the selected path and choose Schematic.

Visual Identification Details:

    - Green color indicates the startpoint of the timing path.
    - Red color indicates the endpoint (destination) of the timing path.
    - Yellow color highlights intermediate or through-points (combinational logic gates and nets)
      along the failing route.

Tracing Back The Timing Problem To High-Level psC

    On the schematic, locate the psC variable and port names embedded  in more complex names.
    The problem often arise when using memories. Memory variable names are "type_mem_name".
    From these names and following the components in the path, you should be able to locate
    the source of the problem back to your psC code.

    Problems are always created when assigning long and complex expressions. To solve the timing
    problem, break the expression using an additional intermediate variable computed the line
    before and used in the expression.

    Variable types may generate complex expression. For example, adding integers introduces
    carray chains. FPGA easily add 4 bits integer, but for 32 bits integer, 7 intermediate carry
    will be inserted. The delay becomes "8 x adders + 7 x carry". This long delay may cause
    timing problem. So, keep all variables to the minimum size required for your computations.
    The same applies to multiplications which handles typically 18bits x 18 bits. For example,
    a 32 bits multiplication requires 4 x DSP multipliers.

    Accessing arrays is performed using a clock double the frequency. For example, if the main
    clock period is 20nsec, the array clock period is 10 nsec. Accessing array in expression
    for assignment or reading lowers the time allowed to 10nsec, which will affect WNS.
    Array are normally implemented using memory blocks. To speedup array access, you can
    use "register" arrays. This forces the compiler to implement arrays with memory LUTs, making
    R/W access time to 20nsec.

--------------------------------------------------\n
    }
} else {
    puts $NovakodReport "  No timing errors."
}

# ---------------------------------------------------------------------------
# Robust Extraction Engine for Vivado Pipe-Delimited Tables
# ---------------------------------------------------------------------------
proc extract_util {report resource} {
    if {$report eq ""} {return {0 0 "0.0"}}

    # Matches: | ResourceName | Used | Col3 | Col4 | Available | Percentage |
    set pattern [format {\|\s*%s\s*\|\s*(\d+)\s*\|[^|]+\|[^|]+\|\s*(\d+)\s*\|\s*([\d\.]+)\s*\|} $resource]

    foreach line [split $report "\n"] {
        if {[regexp -nocase -- $pattern $line -> used avail perc]} {
            return [list $used $avail $perc]
        }
    }
    return {0 0 "0.0"}
}

# ---------------------------------------------------------------------------
# Resource Usage Section
# ---------------------------------------------------------------------------
# Generate raw text report string directly from Vivado memory database
set util_report [report_utilization -return_string]

# Extract data directly using your specific table strings
set lut_data   [extract_util $util_report "Slice LUTs"]
set reg_data   [extract_util $util_report "Slice Registers"]
set bram_data  [extract_util $util_report "Block RAM Tile"]
set dsp_data   [extract_util $util_report "DSPs"]

# ---------------------------------------------------------------------------
# Print the User-Friendly Summary Block to File
# ---------------------------------------------------------------------------
puts $NovakodReport "\n=================================================="
puts $NovakodReport "RESOURCE USAGE SUMMARY"
puts $NovakodReport "--------------------------------------------------"

foreach {label data} [list \
    "Slice LUTs"      $lut_data \
    "Slice Registers" $reg_data \
    "BRAM Tiles"      $bram_data \
    "DSPs"            $dsp_data \
] {
    set used  [lindex $data 0]
    set avail [lindex $data 1]
    set perc  [lindex $data 2]

    puts $NovakodReport [format "%-15s : %7d of %7d (%s%%)" $label $used $avail $perc]
}

puts $NovakodReport "=================================================="

close $NovakodReport
