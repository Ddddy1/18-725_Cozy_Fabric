module cb_tb ();
    logic[3:0] top_in, top_out, bottom_in, bottom_out, left_in, left_out, right_in, right_out;
    logic scan_clk, scan_en, scan_in_vc, scan_in_hc, scan_out;
    logic out0, out1, out2, out3, out4;

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
            scan_in_vc = 1;
            #10;
            scan_in_vc = 0;
            #70;
        end   
    end

    initial begin
        forever begin
            scan_in_hc =1;
            #10;
            scan_in_hc =0;
            #110;
        end
    end

    assign top_in = 4'b0000;
    assign bottom_in = 4'b1111;
    assign right_in = 4'b0000;
    assign left_in = 4'b1111;
    
    vertical_channel vc(.*,.left_clb_in1(out1),.right_clb_in3(out3),.scan_in(scan_in_vc));
    horizontal_channel hc(.*,.top_clb_in2(out2),.bottom_clb_in0(out0),.bottom_clb_in4(out4),.scan_in(scan_in_hc));


endmodule