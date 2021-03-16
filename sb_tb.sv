module sb_tb ();
    logic[3:0] top_in, top_out, bottom_in, bottom_out, left_in, left_out, right_in, right_out;
    logic scan_clk, scan_en, scan_in, scan_out;
    logic left_clb_out, right_clb_out;
    //bitstream
    logic[31:0] bs;
    //LO = left out TO = top out RO = right out BO = bottom out
    logic LO3_MATCH, LO2_MATCH, LO1_MATCH, LO0_MATCH; 
    logic TO3_MATCH, TO2_MATCH, TO1_MATCH, TO0_MATCH; 
    logic RO3_MATCH, RO2_MATCH, RO1_MATCH, RO0_MATCH; 
    logic BO3_MATCH, BO2_MATCH, BO1_MATCH, BO0_MATCH; 
    
    logic ALL_OUT_MATCH, Circuit_Correct;

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
            //randomly assign inputs and bitstream
            top_in = $random;
            bottom_in = $random;
            right_in = $random;
            left_in = $random;
            left_clb_out = $random;
            right_clb_out = $random;
            bs = $random;
            //scan in the bitstream
            scan_en = 1;
            for (int i = 0; i<32 ; i++) begin
                scan_in = bs[31-i];
                #10;
            end
            scan_en = 0;
            //flag circuit incorrect if ALL_OUT_MATCH = 0
            if(~ALL_OUT_MATCH)
                Circuit_Correct = 0;
            #500;
        end   
    end
    
    //Predict output based on control signal into every mux. 
    //This is basically the reverse of bistream generation.
    //We are looking at a randomly generated bitstream and predicting where the signals are from based on the circuit. 

    always_comb begin
        //LO - bs [7:0]
        case (bs[1:0])
            2'b00   : LO0_MATCH = ~(top_in[1]^left_out[0]);
            2'b01   : LO0_MATCH = ~(right_in[0]^left_out[0]);
            2'b10   : LO0_MATCH = ~(bottom_in[2]^left_out[0]);
            2'b11   : if(left_out[0] == 1'bX) LO0_MATCH = 1;
            default : LO0_MATCH = 1'bX;
        endcase

        case (bs[3:2])
            2'b00   : LO1_MATCH = ~(top_in[2]^left_out[1]);
            2'b01   : LO1_MATCH = ~(right_in[1]^left_out[1]);
            2'b10   : LO1_MATCH = ~(bottom_in[1]^left_out[1]);
            2'b11   : if(left_out[1] == 1'bX) LO1_MATCH = 1;
            default : LO1_MATCH = 1'bX;
        endcase

        case (bs[5:4])
            2'b00   : LO2_MATCH = ~(top_in[3]^left_out[2]);
            2'b01   : LO2_MATCH = ~(right_in[2]^left_out[2]);
            2'b10   : LO2_MATCH = ~(bottom_in[0]^left_out[2]);
            2'b11   : if(left_out[2] == 1'bX) LO2_MATCH = 1;
            default : LO2_MATCH = 1'bX;
        endcase

        case (bs[7:6])
            2'b00   : LO3_MATCH = ~(top_in[0]^left_out[3]);
            2'b01   : LO3_MATCH = ~(right_in[3]^left_out[3]);
            2'b10   : LO3_MATCH = ~(bottom_in[3]^left_out[3]);
            2'b11   : LO3_MATCH = ~(left_clb_out^left_out[3]);
            default : LO3_MATCH = 1'bX;
        endcase

        //TO - bs [15:8]
        case (bs[9:8])
            2'b00   : TO0_MATCH = ~(left_in[3]^top_out[0]);
            2'b01   : TO0_MATCH = ~(bottom_in[0]^top_out[0]);
            2'b10   : TO0_MATCH = ~(right_in[2]^top_out[0]);
            2'b11   : if(top_out[0] == 1'bX) TO0_MATCH = 1;
            default : TO0_MATCH = 1'bX;
        endcase

        case (bs[11:10])
            2'b00   : TO1_MATCH = ~(left_in[0]^top_out[1]);
            2'b01   : TO1_MATCH = ~(bottom_in[1]^top_out[1]);
            2'b10   : TO1_MATCH = ~(right_in[1]^top_out[1]);
            2'b11   : if(top_out[1] == 1'bX) TO1_MATCH = 1;
            default : TO1_MATCH = 1'bX;
        endcase

        case (bs[13:12])
            2'b00   : TO2_MATCH = ~(left_in[1]^top_out[2]);
            2'b01   : TO2_MATCH = ~(bottom_in[2]^top_out[2]);
            2'b10   : TO2_MATCH = ~(right_in[0]^top_out[2]);
            2'b11   : if(top_out[2] == 1'bX) TO2_MATCH = 1;
            default : TO2_MATCH = 1'bX;
        endcase

        case (bs[15:14])
            2'b00   : TO3_MATCH = ~(left_in[2]^top_out[3]);
            2'b01   : TO3_MATCH = ~(bottom_in[3]^top_out[3]);
            2'b10   : TO3_MATCH = ~(right_in[3]^top_out[3]);
            2'b11   : if(top_out[3] == 1'bX) TO3_MATCH = 1;
            default : TO3_MATCH = 1'bX;
        endcase
        
        //RO - bs [23:16]
        case (bs[17:16])
            2'b00   : RO0_MATCH = ~(top_in[2]^right_out[0]);
            2'b01   : RO0_MATCH = ~(left_in[0]^right_out[0]);
            2'b10   : RO0_MATCH = ~(bottom_in[3]^right_out[0]);
            2'b11   : if(right_out[0] == 1'bX) RO0_MATCH = 1;
            default : RO0_MATCH = 1'bX;
        endcase

        case (bs[19:18])
            2'b00   : RO1_MATCH = ~(top_in[1]^right_out[1]);
            2'b01   : RO1_MATCH = ~(left_in[1]^right_out[1]);
            2'b10   : RO1_MATCH = ~(bottom_in[0]^right_out[1]);
            2'b11   : if(right_out[1] == 1'bX) RO1_MATCH = 1;
            default : RO1_MATCH = 1'bX;
        endcase

        case (bs[21:20])
            2'b00   : RO2_MATCH = ~(top_in[0]^right_out[2]);
            2'b01   : RO2_MATCH = ~(left_in[2]^right_out[2]);
            2'b10   : RO2_MATCH = ~(bottom_in[1]^right_out[2]);
            2'b11   : if(right_out[2] == 1'bX) RO2_MATCH = 1;
            default : RO2_MATCH = 1'bX;
        endcase

        case (bs[23:22])
            2'b00   : RO3_MATCH = ~(top_in[3]^right_out[3]);
            2'b01   : RO3_MATCH = ~(left_in[3]^right_out[3]);
            2'b10   : RO3_MATCH = ~(bottom_in[2]^right_out[3]);
            2'b11   : RO3_MATCH = ~(right_clb_out^right_out[3]);
            default : RO3_MATCH = 1'bX;
        endcase

        //BO - bs [31:24]
        case (bs[25:24])
            2'b00   : BO0_MATCH = ~(left_in[2]^bottom_out[0]);
            2'b01   : BO0_MATCH = ~(top_in[0]^bottom_out[0]);
            2'b10   : BO0_MATCH = ~(right_in[1]^bottom_out[0]);
            2'b11   : if(bottom_out[0] == 1'bX) BO0_MATCH = 1;
            default : BO0_MATCH = 1'bX;
        endcase

        case (bs[27:26])
            2'b00   : BO1_MATCH = ~(left_in[1]^bottom_out[1]);
            2'b01   : BO1_MATCH = ~(top_in[1]^bottom_out[1]);
            2'b10   : BO1_MATCH = ~(right_in[2]^bottom_out[1]);
            2'b11   : if(bottom_out[1] == 1'bX) BO1_MATCH = 1;
            default : BO1_MATCH = 1'bX;
        endcase

        case (bs[29:28])
            2'b00   : BO2_MATCH = ~(left_in[0]^bottom_out[2]);
            2'b01   : BO2_MATCH = ~(top_in[2]^bottom_out[2]);
            2'b10   : BO2_MATCH = ~(right_in[3]^bottom_out[2]);
            2'b11   : if(bottom_out[2] == 1'bX) BO2_MATCH = 1;
            default : BO2_MATCH = 1'bX;
        endcase

        case (bs[31:30])
            2'b00   : BO3_MATCH = ~(left_in[3]^bottom_out[3]);
            2'b01   : BO3_MATCH = ~(top_in[3]^bottom_out[3]);
            2'b10   : BO3_MATCH = ~(right_in[0]^bottom_out[3]);
            2'b11   : if(bottom_out[3] == 1'bX) BO3_MATCH = 1;
            default : BO3_MATCH = 1'bX;
        endcase
    end
    
    //Update ALL_OUT_MATCH only when scan is complete. 
    always_ff @( posedge scan_clk ) begin
        if(~scan_en)
            ALL_OUT_MATCH <= LO3_MATCH & LO2_MATCH & LO1_MATCH & LO0_MATCH &
                            TO3_MATCH & TO2_MATCH & TO1_MATCH & TO0_MATCH & 
                            RO3_MATCH & RO2_MATCH & RO1_MATCH & RO0_MATCH &
                            BO3_MATCH & BO2_MATCH & BO1_MATCH & BO0_MATCH;                  
        else 
            ALL_OUT_MATCH <= ALL_OUT_MATCH;
    end

    switch_block sb (.*);

endmodule