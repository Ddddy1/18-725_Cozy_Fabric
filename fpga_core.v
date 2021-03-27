module fpga_core(clk, scan_clk, fpga_in, fpga_out,
 clb_scan_in, clb_scan_out, clb_scan_en, conn_scan_in, conn_scan_out, conn_scan_en);

    input clk, scan_clk, clb_scan_in, clb_scan_en, conn_scan_in, conn_scan_en;
    output clb_scan_out, conn_scan_out;
    input[9:0] fpga_in;
    output [9:0] fpga_out;

    wire[31:0] edge_right_arry_left, array_left_edge_right, edge_top_array_bottom, array_bottom_edge_top;
    wire[7:0] clb_out_sb_in, left_cb_right_clb, bottom_cb_top_clb;

    wire conn_scan_conn;

    fpga_edge inst_edge(
        .right_in(array_left_edge_right), 
        .right_out(edge_right_arry_left), 
        .top_in(array_bottom_edge_top), 
        .top_out(edge_top_array_bottom), 
        .right_sb_in(clb_out_sb_in), 
        .right_clb_in(edge_cb_clb_left), 
        .top_clb_in(bottom_cb_top_clb),
        .scan_clk(scan_clk), 
        .conn_scan_en(scan_en), 
        .conn_scan_in(conn_scan_in), 
        .conn_scan_out(conn_scan_conn), 
        .fpga_in(fpga_in), 
        .fpga_out(fpga_out)
    );

    CLB_8x8 inst_CLB_8x8 (
        .clk(clk), 
        .scan_clk(scan_clk), 
        .clb_scan_in(clb_scan_in), 
        .clb_scan_out(clb_scan_out), 
        .clb_scan_en(clb_scan_en), 
        .conn_scan_in(conn_scan_conn), 
        .conn_scan_out(conn_scan_out), 
        .conn_scan_en(conn_scan_en),
        .left_in(edge_right_arry_left), 
        .right_in(), 
        .top_in(), 
        .bottom_in(edge_top_array_bottom), 
        .left_out(array_left_edge_right), 
        .right_out(), 
        .top_out(), 
        .bottom_out(array_bottom_edge_top), 
	    .left_clb_out(clb_out_sb_in), 
        .left_clb_in(left_cb_right_clb), 
        .bottom_clb_in(bottom_cb_top_clb),
        .right_sb_in(), 
	    .top_cb_out(), 
        .right_cb_out()
    );
endmodule