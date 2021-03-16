module cb_tb ();
    logic[3:0] top_in, top_out, bottom_in, bottom_out, left_in, left_out, right_in, right_out;
    logic scan_clk, scan_en, scan_in_vc, scan_in_hc, scan_out_vc, scan_out_hc;
    logic out0, out1, out2, out3;

    //logic 1 signals a match. 
    logic IN_OUT_MATCH_VC, IN_OUT_MATCH_HC;
    logic OUT0_MATCH, OUT1_MATCH, OUT2_MATCH, OUT3_MATCH, ALL_OUT_MATCH, Circuit_Correct;
    //bitstream 
    logic[1:0] bs_hc_0, bs_vc_1, bs_hc_2, bs_vc_3;

    initial begin
        scan_clk = 0;
        Circuit_Correct = 1;
        forever begin
            #5;
            scan_clk = ~scan_clk;
        end
    end

    initial begin
        forever begin
            //randomly generate inputs and bitstream
            top_in = $random;
            bottom_in = $random;
            right_in = $random;
            left_in = $random;
            bs_hc_0 = $random;
            bs_vc_1 = $random;
            bs_hc_2 = $random;
            bs_vc_3 = $random;
            //scan in the bitstream
            scan_en = 1;
            scan_in_vc = bs_vc_3[1];
            scan_in_hc = bs_hc_2[1];
            #10;
            scan_in_vc = bs_vc_3[0];
            scan_in_hc = bs_hc_2[0];
            #10;
            scan_in_vc = bs_vc_1[1];
            scan_in_hc = bs_hc_0[1];
            #10;
            scan_in_vc = bs_vc_1[0];
            scan_in_hc = bs_hc_0[0];
            #10;
            scan_en = 0;
            //flag circuit incorrect if ALL_OUT_MATCH = 0
            if(~ALL_OUT_MATCH)
                Circuit_Correct = 0;
            //Wait for human inspection
            #200;
        end   
    end


    assign IN_OUT_MATCH_VC = ~((top_in^bottom_out)|(top_out^bottom_in));
    assign IN_OUT_MATCH_HC = ~((left_in^right_out)|(left_out^right_in));


    //Predict output based on bitstream and assign corresponding MATCH signals 
    //Look at the connections shown in vtr if confused. 
    always_comb begin
        case (bs_vc_1)
            2'b00: OUT1_MATCH = ~(bottom_in[0]^out1);
            2'b01: OUT1_MATCH = ~(top_in[0]^out1);
            2'b10: OUT1_MATCH = ~(bottom_in[2]^out1);
            2'b11: OUT1_MATCH = ~(top_in[2]^out1);
            default: OUT1_MATCH = 1'bX;
        endcase
    end

    always_comb begin
        case (bs_vc_3)
            2'b00: OUT3_MATCH = ~(bottom_in[1]^out3);
            2'b01: OUT3_MATCH = ~(top_in[1]^out3);
            2'b10: OUT3_MATCH = ~(bottom_in[3]^out3);
            2'b11: OUT3_MATCH = ~(top_in[3]^out3);
            default: OUT3_MATCH = 1'bX;
        endcase
    end

    always_comb begin
        case (bs_hc_0)
            2'b00: OUT0_MATCH = ~(right_in[1]^out0);
            2'b01: OUT0_MATCH = ~(left_in[1]^out0);
            2'b10: OUT0_MATCH = ~(right_in[3]^out0);
            2'b11: OUT0_MATCH = ~(left_in[3]^out0);
            default: OUT0_MATCH = 1'bX; 
        endcase
    end

    always_comb begin
        case (bs_hc_2)
            2'b00: OUT2_MATCH = ~(right_in[0]^out2);
            2'b01: OUT2_MATCH = ~(left_in[0]^out2);
            2'b10: OUT2_MATCH = ~(right_in[2]^out2);
            2'b11: OUT2_MATCH = ~(left_in[2]^out2);
            default: OUT2_MATCH = 1'bX; 
        endcase
    end

    always_ff @( posedge scan_clk ) begin
        if(~scan_en)
            ALL_OUT_MATCH <= OUT1_MATCH & OUT3_MATCH & OUT0_MATCH & OUT2_MATCH;
        else
            ALL_OUT_MATCH <= ALL_OUT_MATCH;
    end

    vertical_channel vc(.*,.left_clb_in1(out1),.right_clb_in3(out3),.scan_in(scan_in_vc),.scan_out(scan_out_vc));
    horizontal_channel hc(.*,.top_clb_in2(out2),.bottom_clb_in0(out0),.scan_in(scan_in_hc),.scan_out(scan_out_hc));

endmodule