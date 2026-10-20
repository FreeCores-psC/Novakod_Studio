# Load required Quartus packages
load_package project
load_package report

# Ensure arguments are provided or set project variables directly
set project_name "your_project_name"
set revision_name "your_revision_name"
set output_file "resource_report.txt"

# Open the project and load the compilation report
project_open $project_name -revision $revision_name
load_report

# Helper procedure to get value from Flow Summary panel
proc get_report_value_safe {panel_name row_name} {
    set panel_id [get_report_panel_id $panel_name]
    if {$panel_id == -1} { return "N/A" }
    set num_rows [get_number_of_rows -id $panel_id]
    for {set i 0} {$i < $num_rows} {incr i} {
        set row_data [get_report_panel_row -id $panel_id -row $i]
        set label [lindex $row_data 0]
        if {[string match -nocase "$row_name*" $label]} {
            return [lindex $row_data 1]
        }
    }
    return "N/A"
}

# Fetch metrics
set flow_summary "Flow Summary"
set luts [get_report_value_safe $flow_summary "Total Logic Utilization"]
set regs [get_report_value_safe $flow_summary "Total Registers"]
set mem  [get_report_value_safe $flow_summary "Total Memory Bits"]
set dsp  [get_report_value_safe $flow_summary "DSP Blocks"]

# Open file for writing
set fh [open $output_file w]

# Write Basic Resource Report to file
puts $fh "=== BASIC FPGA RESOURCE UTILIZATION REPORT ==="
puts $fh "Project:  $project_name"
puts $fh "Revision: $revision_name"
puts $fh "--------------------------------------------------"
puts $fh [format "%-35s : %s" "Total Logic Utilization (LUTs/ALMs)" $luts]
puts $fh [format "%-35s : %s" "Total Registers" $regs]
puts $fh [format "%-35s : %s" "Total Memory Bits" $mem]
puts $fh [format "%-35s : %s" "DSP Blocks" $dsp]
puts $fh "--------------------------------------------------"

# Close file, report, and project
close $fh
post_message "Resource report saved to $output_file"

unload_report
project_close
