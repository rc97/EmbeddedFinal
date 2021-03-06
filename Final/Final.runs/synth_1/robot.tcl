# 
# Synthesis run script generated by Vivado
# 

set_param xicom.use_bs_reader 1
set_msg_config -id {Common 17-41} -limit 10000000
create_project -in_memory -part xc7z010clg400-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir C:/CodingProjects/EmbeddedFinal/Final/Final.cache/wt [current_project]
set_property parent.project_path C:/CodingProjects/EmbeddedFinal/Final/Final.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language VHDL [current_project]
set_property ip_output_repo c:/CodingProjects/EmbeddedFinal/Final/Final.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_vhdl -library xil_defaultlib {
  C:/CodingProjects/EmbeddedFinal/Final/Final.srcs/sources_1/imports/new/clock_div_115200.vhd
  C:/CodingProjects/EmbeddedFinal/Final/Final.srcs/sources_1/new/pwm.vhd
  C:/CodingProjects/EmbeddedFinal/Final/Final.srcs/sources_1/imports/sources_1/rx.vhd
  C:/CodingProjects/EmbeddedFinal/Final/Final.srcs/sources_1/imports/sources_1/tx.vhd
}
read_vhdl -vhdl2008 -library xil_defaultlib {
  C:/CodingProjects/EmbeddedFinal/Final/Final.srcs/sources_1/imports/sources_1/uart.vhd
  C:/CodingProjects/EmbeddedFinal/Final/Final.srcs/sources_1/new/robot.vhd
}
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/CodingProjects/EmbeddedFinal/Final/Final.srcs/constrs_1/imports/Downloads/ZYBO_Master.xdc
set_property used_in_implementation false [get_files C:/CodingProjects/EmbeddedFinal/Final/Final.srcs/constrs_1/imports/Downloads/ZYBO_Master.xdc]


synth_design -top robot -part xc7z010clg400-1


write_checkpoint -force -noxdef robot.dcp

catch { report_utilization -file robot_utilization_synth.rpt -pb robot_utilization_synth.pb }
