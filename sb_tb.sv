module sb_tb ();
    logic[3:0] top_in, top_out, bottom_in, bottom_out, left_in, left_out, right_in, right_out;
    logic scan_clk, scan_en, scan_in, scan_out;
    logic left_clb_out, right_clb_out;

    initial begin
        scan_clk = 0;
        forever begin
            #5;
            scan_clk = ~scan_clk;
        end
    end

    initial begin
        forever begin
            scan_en  = 1;
            scan_in = 1;
            #10;
            scan_in = 0;
            #310;
        end   
    end

    assign left_clb_out = 1;
    assign right_clb_out = 1;
    assign top_in = 4'b0000;
    assign bottom_in = 4'b1111;
    assign right_in = 4'b0000;
    assign left_in = 4'b0000;

    switch_block sb (.*);

endmodule