



module Convolution(
// input 
input clk ,
input rst_n ,
input in_valid ,
input weight_valid ,
input [7:0] In_IFM_1,
input [7:0] In_IFM_2,
input [7:0] In_IFM_3,
input [7:0] In_IFM_4,
input [7:0] In_IFM_5,
input [7:0] In_IFM_6,
input [7:0] In_IFM_7,
input [7:0] In_IFM_8,	
input [7:0] In_IFM_9,	
input [7:0] In_Weight_1,
input [7:0] In_Weight_2,
input [7:0] In_Weight_3,
input [7:0] In_Weight_4,
input [7:0] In_Weight_5,
input [7:0] In_Weight_6,
input [7:0] In_Weight_7,
input [7:0] In_Weight_8,
input [7:0] In_Weight_9,
// output 
output reg 	out_valid,
output reg [20:0] Out_OFM
);
// Buffer 
reg [7:0] In_IFM_1_buf ;
reg [7:0] In_IFM_2_buf ;
reg [7:0] In_IFM_3_buf ;
reg [7:0] In_IFM_4_buf ;
reg [7:0] In_IFM_5_buf ;
reg [7:0] In_IFM_6_buf ;
reg [7:0] In_IFM_7_buf ;
reg [7:0] In_IFM_8_buf ;	
reg [7:0] In_IFM_9_buf ;	
reg [7:0] In_Weight_1_buf ;
reg [7:0] In_Weight_2_buf ;
reg [7:0] In_Weight_3_buf ;
reg [7:0] In_Weight_4_buf ;
reg [7:0] In_Weight_5_buf ;
reg [7:0] In_Weight_6_buf ;
reg [7:0] In_Weight_7_buf ;
reg [7:0] In_Weight_8_buf ;
reg [7:0] In_Weight_9_buf ;

// Finite State Machine
localparam IDLE = 1'b0 ;
localparam WORK = 1'b1 ;
reg ConvState ;
reg NextState ;

// Counter
// to count how many output has done
reg [4:0] out_count ; // 0~25
always @(posedge clk) begin
    case (ConvState)
        IDLE: out_count <= 5'd0 ;
        WORK: out_count <= out_count+1 ;
        default: out_count <= 5'd0 ;
    endcase
end

// State switch
always @ (posedge clk or negedge rst_n) begin :FSM_Conv
    if (~rst_n) begin
        ConvState <= IDLE ;
    end else begin
        ConvState <= NextState ;
    end
end
// Next state
always @(*) begin
    case (ConvState)
        IDLE: NextState = (in_valid)?(WORK):(IDLE) ;
        WORK: NextState = (out_count == 5'd24)?(IDLE):(WORK) ;
        default: NextState = (in_valid)?(WORK):(IDLE) ;
    endcase
end 

// Calculation 
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        out_valid <= 0 ;
        Out_OFM   <= 21'b0;
    end else begin
        case (ConvState)
            IDLE : begin
                out_valid <= 0 ;
                Out_OFM   <= 21'b0;
            end
            WORK : begin
                out_valid <= 1 ;
                Out_OFM <=  In_IFM_1_buf * In_Weight_1_buf +
                            In_IFM_2_buf * In_Weight_2_buf +
                            In_IFM_3_buf * In_Weight_3_buf +
                            In_IFM_4_buf * In_Weight_4_buf +
                            In_IFM_5_buf * In_Weight_5_buf +
                            In_IFM_6_buf * In_Weight_6_buf +
                            In_IFM_7_buf * In_Weight_7_buf +
                            In_IFM_8_buf * In_Weight_8_buf +
                            In_IFM_9_buf * In_Weight_9_buf ;
            end
            default: begin
                out_valid <= 0 ;
                Out_OFM   <= 21'b0;
            end
        endcase
    end
end

// Data -> Buffer  
always @(posedge clk) begin
    In_IFM_1_buf <= (in_valid)?(In_IFM_1):(In_IFM_1_buf) ;
    In_IFM_2_buf <= (in_valid)?(In_IFM_2):(In_IFM_2_buf) ;
    In_IFM_3_buf <= (in_valid)?(In_IFM_3):(In_IFM_3_buf) ;
    In_IFM_4_buf <= (in_valid)?(In_IFM_4):(In_IFM_4_buf) ;
    In_IFM_5_buf <= (in_valid)?(In_IFM_5):(In_IFM_5_buf) ;
    In_IFM_6_buf <= (in_valid)?(In_IFM_6):(In_IFM_6_buf) ;
    In_IFM_7_buf <= (in_valid)?(In_IFM_7):(In_IFM_7_buf) ;
    In_IFM_8_buf <= (in_valid)?(In_IFM_8):(In_IFM_8_buf) ;	
    In_IFM_9_buf <= (in_valid)?(In_IFM_9):(In_IFM_9_buf) ;	
    In_Weight_1_buf <= (weight_valid)?(In_Weight_1):(In_Weight_1_buf) ;
    In_Weight_2_buf <= (weight_valid)?(In_Weight_2):(In_Weight_2_buf) ;
    In_Weight_3_buf <= (weight_valid)?(In_Weight_3):(In_Weight_3_buf) ;
    In_Weight_4_buf <= (weight_valid)?(In_Weight_4):(In_Weight_4_buf) ;
    In_Weight_5_buf <= (weight_valid)?(In_Weight_5):(In_Weight_5_buf) ;
    In_Weight_6_buf <= (weight_valid)?(In_Weight_6):(In_Weight_6_buf) ;
    In_Weight_7_buf <= (weight_valid)?(In_Weight_7):(In_Weight_7_buf) ;
    In_Weight_8_buf <= (weight_valid)?(In_Weight_8):(In_Weight_8_buf) ;
    In_Weight_9_buf <= (weight_valid)?(In_Weight_9):(In_Weight_9_buf) ;
end

endmodule