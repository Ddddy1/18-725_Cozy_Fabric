parameter channel_width = 8;

module switch_matrix (
    input   logic [channel_width/2-1:0] left_in,
    input   logic [channel_width/2-1:0] right_in,   
    input   logic [channel_width/2-1:0] top_in,
    input   logic [channel_width/2-1:0] bottom_in,
    output  logic [channel_width/2-1:0] left_out,
    output  logic [channel_width/2-1:0] right_out,
    output  logic [channel_width/2-1:0] top_out,
    output  logic [channel_width/2-1:0] bottom_out
);
    //编号都是从左往右 从上到下
    //horizontal mux
    logic [1:0] ctrl_L [0:3];
    logic [1:0] ctrl_R [0:3];
    logic [1:0] ctrl_T [0:3];
    logic [1:0] ctrl_B [0:3];
    mux3 mux_L_0(.out(left_out[0]),.in(top_in[1]right_in[0]bottom_in[2]));
    

    module mux3(
        input logic [2:0] in,
        input logic [1:0]ctrl,
        output logic out
    );
        always_comb begin
            if (ctrl==2'b00) 
                out = in[0];
            if (ctrl==2'b01) 
                out = in[1];
            if (ctrl==2'b10)
                out = in[2];
        end
    endmodule

    module mux4 (
        input logic [3:0] in,
        input logic [1:0]ctrl,
        output logic out
    );
        always_comb begin
            if (ctrl==2'b00) 
                out = in[0];
            if (ctrl==2'b01) 
                out = in[1];
            if (ctrl==2'b10) 
                out = in[2];
            if (ctrl==2'b11) 
                out = in[3];
        end
    endmodule
   

endmodule