parameter channel_width = 8;

module switch_block (
    input   logic [channel_width/2-1:0] left_in,
    input   logic [channel_width/2-1:0] right_in,   
    input   logic [channel_width/2-1:0] top_in,
    input   logic [channel_width/2-1:0] bottom_in,
    output  logic [channel_width/2-1:0] left_out,
    output  logic [channel_width/2-1:0] right_out,
    output  logic [channel_width/2-1:0] top_out,
    output  logic [channel_width/2-1:0] bottom_out,
    input   logic left_clb_out, right_clb_out,
    input logic scan_in, scan_en, scan_clk,
    output logic scan_out
);
    //编号都是从左往右 从上到下
    //horizontal mux
    wire [1:0] ctrl_L [0:3];
    wire [1:0] ctrl_R [0:3];
    wire [1:0] ctrl_T [0:3];
    wire [1:0] ctrl_B [0:3];
    wire scan_conn1;
    wire scan_conn2;
    wire scan_conn3;

    ROM_8 #(.width(8)) mux_ctrl_L (.*,.scan_out(scan_conn1),.out({ctrl_L[3],ctrl_L[2],ctrl_L[1],ctrl_L[0]}));
    ROM_8 #(.width(8)) mux_ctrl_T (.*,.scan_in(scan_conn1),.scan_out(scan_conn2),.out({ctrl_T[3],ctrl_T[2],ctrl_T[1],ctrl_T[0]}));
    ROM_8 #(.width(8)) mux_ctrl_R (.*,.scan_in(scan_conn2),.scan_out(scan_conn3),.out({ctrl_R[3],ctrl_R[2],ctrl_R[1],ctrl_R[0]}));
    ROM_8 #(.width(8)) mux_ctrl_B (.*,.scan_in(scan_conn3),.out({ctrl_B[3],ctrl_B[2],ctrl_B[1],ctrl_B[0]}));

    //  CTRL                             00          01           10
    mux3 mux_L_0(.out(left_out[0]),.in({top_in[1],right_in[0],bottom_in[2]}),.ctrl(ctrl_L[0]));
    mux3 mux_L_1(.out(left_out[1]),.in({top_in[2],right_in[1],bottom_in[1]}),.ctrl(ctrl_L[1]));
    mux3 mux_L_2(.out(left_out[2]),.in({top_in[3],right_in[2],bottom_in[0]}),.ctrl(ctrl_L[2]));
    //  CTRL                               00          01           10            11                                   
    mux4 mux_L_3(.out(left_out[3]),.in({top_in[0],right_in[3],bottom_in[3],left_clb_out}),.ctrl(ctrl_L[3]));

    //  CTRL                               00          01           10
    mux3 mux_R_0(.out(right_out[0]),.in({top_in[2],left_in[0],bottom_in[3]}),.ctrl(ctrl_R[0]));
    mux3 mux_R_1(.out(right_out[1]),.in({top_in[1],left_in[1],bottom_in[0]}),.ctrl(ctrl_R[1]));
    mux3 mux_R_2(.out(right_out[2]),.in({top_in[0],left_in[2],bottom_in[1]}),.ctrl(ctrl_R[2]));
    //  CTRL                               00          01           10            11     
    mux4 mux_R_3(.out(right_out[3]),.in({top_in[3],left_in[3],bottom_in[2],right_clb_out}),.ctrl(ctrl_R[3]));

    //  CTRL                               00          01           10
    mux3 mux_T_0(.out(top_out[0]),.in({left_in[3],bottom_in[0],right_in[2]}),.ctrl(ctrl_T[0]));
    mux3 mux_T_1(.out(top_out[1]),.in({left_in[0],bottom_in[1],right_in[1]}),.ctrl(ctrl_T[1]));
    mux3 mux_T_2(.out(top_out[2]),.in({left_in[1],bottom_in[2],right_in[0]}),.ctrl(ctrl_T[2]));
    mux3 mux_T_3(.out(top_out[3]),.in({left_in[2],bottom_in[3],right_in[3]}),.ctrl(ctrl_T[3]));

    //  CTRL                                 00          01           10
    mux3 mux_B_0(.out(bottom_out[0]),.in({left_in[2],top_in[0],right_in[1]}),.ctrl(ctrl_B[0]));
    mux3 mux_B_1(.out(bottom_out[1]),.in({left_in[1],top_in[1],right_in[2]}),.ctrl(ctrl_B[1]));
    mux3 mux_B_2(.out(bottom_out[2]),.in({left_in[0],top_in[2],right_in[3]}),.ctrl(ctrl_B[2]));
    mux3 mux_B_3(.out(bottom_out[3]),.in({left_in[3],top_in[3],right_in[0]}),.ctrl(ctrl_B[3]));

    module mux3(
        input logic [2:0] in,
        input logic [1:0] ctrl,
        output logic out
    );
        always_comb begin
            if (ctrl==2'b00) 
                out = in[2];
            else if (ctrl==2'b01) 
                out = in[1];
            else if (ctrl==2'b10)
                out = in[0];
            else
                out = 1'bX;
        end
    endmodule

    module mux4 (
        input logic [3:0] in,
        input logic [1:0] ctrl,
        output logic out
    );
        always_comb begin
            if (ctrl==2'b00) 
                out = in[3];
            else if (ctrl==2'b01) 
                out = in[2];
            else if (ctrl==2'b10) 
                out = in[1];
            else if (ctrl==2'b11) 
                out = in[0];
            else 
                out = 1'bX;
        end
    endmodule

    module ROM_8 #(
        parameter width=8
    ) ( 
        input logic scan_in, scan_clk, scan_en,
        output logic scan_out,
        output logic [width-1:0] out
    );
        reg [width-1:0] data;
        always_ff @(posedge scan_clk) begin
            if(scan_en) 
                data <= {data[width-2:0],scan_in};
            else
                data <= data;
        end 
        assign out = data;
        assign scan_out = data[width-1];
    endmodule
   

endmodule