parameter channel_width = 8;
 

module vertical_channel (
    input  logic[channel_width/2-1:0] top_in,
    input  logic[channel_width/2-1:0] bottom_in,
    output logic[channel_width/2-1:0] top_out,
    output logic[channel_width/2-1:0] bottom_out,
    output logic left_clb_in1, right_clb_in3
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
    
    //TODO: add memory cells here and assign ctrl signals to memory
    logic[channel_width/2-1:0] ctrl1, ctrl3;
    
    //tg1_0 means the connection from clb port1 to channel 0
    tg tg1_0(.control(ctrl1[0]),.in(channel[0]),.out(left_clb_in1));
    tg tg1_1(.control(ctrl1[1]),.in(channel[1]),.out(left_clb_in1));
    tg tg1_4(.control(ctrl1[2]),.in(channel[4]),.out(left_clb_in1));
    tg tg1_5(.control(ctrl1[3]),.in(channel[5]),.out(left_clb_in1));

    tg tg3_2(.control(ctrl3[0]),.in(channel[2]),.out(right_clb_in3));
    tg tg3_3(.control(ctrl3[1]),.in(channel[3]),.out(right_clb_in3));
    tg tg3_6(.control(ctrl3[2]),.in(channel[6]),.out(right_clb_in3));
    tg tg3_7(.control(ctrl3[3]),.in(channel[7]),.out(right_clb_in3));
endmodule

module horizontal_channel (
    input  logic[channel_width/2-1:0] left_in,
    input  logic[channel_width/2-1:0] right_in,
    output logic[channel_width/2-1:0] left_out,
    output logic[channel_width/2-1:0] right_out,
    output logic top_clb_in2, bottom_clb_in0, bottom_clb_in4
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
    
    //TODO: add memory cells here and assign ctrl signals to memory
    logic[channel_width/2-1:0] ctrl0, ctrl2, ctrl4;

    tg tg0_2(.control(ctrl0[0]),.in(channel[2]),.out(bottom_clb_in0));
    tg tg0_3(.control(ctrl0[1]),.in(channel[3]),.out(bottom_clb_in0));
    tg tg0_6(.control(ctrl0[2]),.in(channel[6]),.out(bottom_clb_in0));
    tg tg0_7(.control(ctrl0[3]),.in(channel[7]),.out(bottom_clb_in0));

    tg tg2_2(.control(ctrl2[0]),.in(channel[2]),.out(top_clb_in2));
    tg tg2_3(.control(ctrl2[1]),.in(channel[3]),.out(top_clb_in2));
    tg tg2_6(.control(ctrl2[2]),.in(channel[6]),.out(top_clb_in2));
    tg tg2_7(.control(ctrl2[3]),.in(channel[7]),.out(top_clb_in2));

    tg tg4_0(.control(ctrl4[0]),.in(channel[0]),.out(bottom_clb_in4));
    tg tg4_1(.control(ctrl4[1]),.in(channel[1]),.out(bottom_clb_in4));
    tg tg4_4(.control(ctrl4[2]),.in(channel[4]),.out(bottom_clb_in4));
    tg tg4_5(.control(ctrl4[3]),.in(channel[5]),.out(bottom_clb_in4 ));
endmodule

//transmission gate
module tg  (
    input logic control,
    input wire in,
    output wire out
);
    wire control_inv;
    assign control_inv = control;
    nmos n1 (out, in, control);
    pmos p1 (out, in, control_inv);
endmodule