parameter channel_width = 8;
 
module vertical_channel (
    input  logic[channel_width/2-1:0] top_in,
    input  logic[channel_width/2-1:0] bottom_in,
    output logic[channel_width/2-1:0] top_out,
    output logic[channel_width/2-1:0] bottom_out,
    output logic left_clb_in1, right_clb_in3,
    input logic scan_in, scan_en, scan_clk,
    output logic scan_out
);
    wire[channel_width:0] channel;
    //所有编号都是从左往右 从上到下
    assign channel[0] = bottom_in[0];
    assign channel[1] =    top_in[0];
    assign channel[2] = bottom_in[1];
    assign channel[3] =    top_in[1];
    assign channel[4] = bottom_in[2];
    assign channel[5] =    top_in[2];
    assign channel[6] = bottom_in[3];
    assign channel[7] =    top_in[3];

    assign    top_out[0] = channel[0];
    assign bottom_out[0] = channel[1];
    assign    top_out[1] = channel[2];
    assign bottom_out[1] = channel[3];
    assign    top_out[2] = channel[4];
    assign bottom_out[2] = channel[5];
    assign    top_out[3] = channel[6];
    assign bottom_out[3] = channel[7];
    
    logic[1:0] ctrl1, ctrl3;
    logic scan_conn;
    ROM #(.width(2)) tg_ctrl_1 (.out(ctrl1),.scan_in(scan_in),.scan_out(scan_conn),.scan_en(scan_en),.scan_clk(scan_clk));
    ROM #(.width(2)) tg_ctrl_3 (.out(ctrl3),.scan_in(scan_conn),.scan_out(scan_out),.scan_en(scan_en),.scan_clk(scan_clk));

    MUX4 out1_mux(.control(ctrl1),.in({channel[5],channel[4],channel[1],channel[0]}),.out(left_clb_in1));
    MUX4 out3_mux(.control(ctrl3),.in({channel[7],channel[6],channel[3],channel[2]}),.out(right_clb_in3));

endmodule

module horizontal_channel (
    input  logic[channel_width/2-1:0] left_in,
    input  logic[channel_width/2-1:0] right_in,
    output logic[channel_width/2-1:0] left_out,
    output logic[channel_width/2-1:0] right_out,
    output logic top_clb_in2, bottom_clb_in0, 
    input logic scan_in, scan_en, scan_clk,
    output logic scan_out
);
    logic[channel_width:0] channel;
    //所有编号都是从左往右 从上到下
    assign channel[0] = right_in[0];
    assign channel[1] =  left_in[0];
    assign channel[2] = right_in[1];
    assign channel[3] =  left_in[1];
    assign channel[4] = right_in[2];
    assign channel[5] =  left_in[2];
    assign channel[6] = right_in[3];
    assign channel[7] =  left_in[3];

    assign  left_out[0] = channel[0];
    assign right_out[0] = channel[1];
    assign  left_out[1] = channel[2];
    assign right_out[1] = channel[3];
    assign  left_out[2] = channel[4];
    assign right_out[2] = channel[5];
    assign  left_out[3] = channel[6];
    assign right_out[3] = channel[7];
    
    logic[1:0] ctrl0, ctrl2;
    logic scan_conn;
    ROM #(.width(2)) tg_ctrl_0(.out(ctrl0),.scan_in(scan_in),.scan_out(scan_conn),.scan_en(scan_en),.scan_clk(scan_clk));
    ROM #(.width(2)) tg_ctrl_2(.out(ctrl2),.scan_in(scan_conn),.scan_out(scan_out),.scan_en(scan_en),.scan_clk(scan_clk));

    MUX4 out0_mux(.control(ctrl0),.in({channel[7],channel[6],channel[3],channel[2]}),.out(bottom_clb_in0));
    MUX4 out2_mux(.control(ctrl2),.in({channel[5],channel[4],channel[1],channel[0]}),.out(top_clb_in2));


endmodule

//MUX4 used instead of transmission gate
module MUX4 (
    input logic [1:0] control,
    input logic [3:0] in,
    output logic out
);
    assign out = in[control];

endmodule


//Programmable ROM via scan chain
module ROM #(
    parameter width = 2
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
