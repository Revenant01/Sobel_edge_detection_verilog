vlib work
vlog sobel_matrix_conv.v sqrt.v controller.v sobel_top.v sobel_top_tb.v
vsim -voptargs=+acc work.sobel_top_tb 
# add wave -r /sobel_top_tb/uut/controller_inst/*
# add wave -r /sobel_top_tb/uut/sqrt_inst/*


# add wave -r /sobel_top_tb/uut/controller_inst/clk
# add wave -r /sobel_top_tb/uut/controller_inst/state
# add wave -r /sobel_top_tb/uut/controller_inst/window_index
# add wave -r /sobel_top_tb/uut/controller_inst/delayed_window_index
# add wave -r /sobel_top_tb/uut/controller_inst/sqrt_sq
# add wave -r /sobel_top_tb/uut/
# controller_inst/sum
# add wave -r /sobel_top_tb/uut/controller_inst/Threshold
# add wave -r /sobel_top_tb/uut/controller_inst/thrs


add wave -r /sobel_top_tb/uut/controller_inst/*
run 5 ms 



