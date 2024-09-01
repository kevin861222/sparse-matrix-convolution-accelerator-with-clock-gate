// with clock gating

// synopsys translate_off
`include "../01_RTL/asap7sc7p5t_SEQ_RVT_TT_08302018.v"
// synopsys translate_on

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
output [20:0] Out_OFM 
);
reg [20:0] Out_OFM_reg ;

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

// Enable wire for clock gating
wire EN_IN1 ;
// wire EN_IN2 ;
// wire EN_IN3 ;
// wire EN_IN4 ;
// wire EN_IN5 ;
// wire EN_IN6 ;
// wire EN_IN7 ;
// wire EN_IN8 ;
// wire EN_IN9 ;
wire EN_OUT ;

// CG
wire clk_gate_IN1 ;
// wire clk_gate_IN2 ;
// wire clk_gate_IN3 ;
// wire clk_gate_IN4 ;
// wire clk_gate_IN5 ;
// wire clk_gate_IN6 ;
// wire clk_gate_IN7 ;
// wire clk_gate_IN8 ;
// wire clk_gate_IN9 ;
wire clk_gate_OUT ;
wire clk_gate_W ;

// REG to determine whether next calculate is need to gate.
reg WhetherCG_IN1 ; 
// reg WhetherCG_IN2 ; 
// reg WhetherCG_IN3 ; 
// reg WhetherCG_IN4 ; 
// reg WhetherCG_IN5 ; 
// reg WhetherCG_IN6 ; 
// reg WhetherCG_IN7 ; 
// reg WhetherCG_IN8 ; 
// reg WhetherCG_IN9 ; 
reg WhetherCG_OUT ;
// reg WhetherCG_OUT_2 ;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        WhetherCG_IN1 <= 1 ;
        WhetherCG_OUT <= 1 ;
    end else begin
        WhetherCG_IN1 <= EN_IN1 ;
        WhetherCG_OUT <= WhetherCG_IN1 ;
    end
    // WhetherCG_IN2 <= EN_IN2 ;
    // WhetherCG_IN3 <= EN_IN3 ;
    // WhetherCG_IN4 <= EN_IN4 ;
    // WhetherCG_IN5 <= EN_IN5 ;
    // WhetherCG_IN6 <= EN_IN6 ;
    // WhetherCG_IN7 <= EN_IN7 ;
    // WhetherCG_IN8 <= EN_IN8 ;
    // WhetherCG_IN9 <= EN_IN9 ;
end
// always @(posedge clk or negedge rst_n) begin
//     if (~rst_n) begin
//         WhetherCG_OUT <= 1 ;
//         WhetherCG_OUT_2 <= 1 ;
//     end else begin
//         WhetherCG_OUT <= clk_gate_IN1 ;
//         WhetherCG_OUT_2 <= WhetherCG_OUT ;
//     end
// end

// Output mux
assign Out_OFM = (~WhetherCG_OUT) ? (21'd0) : (Out_OFM_reg) ;


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

// CG condition
// When [ valid = 0 ]   -> gate
// When [ In Data = 0 ] -> gate
// assign EN_IN1 = !(( In_IFM_1 == 8'd0 )||(In_Weight_1_buf == 8'd0 ));
// assign EN_IN2 = !(( In_IFM_2 == 8'd0 )||(In_Weight_2_buf == 8'd0 ));
// assign EN_IN3 = !(( In_IFM_3 == 8'd0 )||(In_Weight_3_buf == 8'd0 ));
// assign EN_IN4 = !(( In_IFM_4 == 8'd0 )||(In_Weight_4_buf == 8'd0 ));
// assign EN_IN5 = !(( In_IFM_5 == 8'd0 )||(In_Weight_5_buf == 8'd0 ));
// assign EN_IN6 = !(( In_IFM_6 == 8'd0 )||(In_Weight_6_buf == 8'd0 ));
// assign EN_IN7 = !(( In_IFM_7 == 8'd0 )||(In_Weight_7_buf == 8'd0 ));
// assign EN_IN8 = !(( In_IFM_8 == 8'd0 )||(In_Weight_8_buf == 8'd0 ));
// assign EN_IN9 = !(( In_IFM_9 == 8'd0 )||(In_Weight_9_buf == 8'd0 ));
// assign EN_IN1 = !(( In_IFM_1 == 8'd0 ));
// assign EN_IN2 = !(( In_IFM_2 == 8'd0 ));
// assign EN_IN3 = !(( In_IFM_3 == 8'd0 ));
// assign EN_IN4 = !(( In_IFM_4 == 8'd0 ));
// assign EN_IN5 = !(( In_IFM_5 == 8'd0 ));
// assign EN_IN6 = !(( In_IFM_6 == 8'd0 ));
// assign EN_IN7 = !(( In_IFM_7 == 8'd0 ));
// assign EN_IN8 = !(( In_IFM_8 == 8'd0 ));
// assign EN_IN9 = !(( In_IFM_9 == 8'd0 ));

assign EN_IN1 = In_IFM_1 || In_IFM_2 || In_IFM_3 || In_IFM_4 || In_IFM_5 || In_IFM_6 || In_IFM_7 || In_IFM_8 || In_IFM_9 ;
// assign EN_OUT = EN_IN1 | EN_IN2 | EN_IN3 | EN_IN4 | EN_IN5 | EN_IN6 | EN_IN7 | EN_IN8 | EN_IN9 ;

// Calculation 
// out valid
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        out_valid <= 0 ;
    end else begin
        case (ConvState)
            IDLE: begin 
                out_valid <= 0 ;
            end

            WORK : begin
                out_valid <= 1 ;
            end
            default: begin
                out_valid <= 0 ;
            end                
        endcase
    end
end

// reg of Out_OFM
always @(posedge clk_gate_OUT or negedge rst_n) begin
    if (~rst_n) begin
        Out_OFM_reg   <= 21'b0;
    end else begin
        case (ConvState)
            IDLE : begin
                Out_OFM_reg   <= Out_OFM_reg ;
            end
            WORK : begin
                // with CG
                // Out_OFM_reg <=  ({16{WhetherCG_IN1}} & (In_IFM_1_buf * In_Weight_1_buf)) +
                //                 ({16{WhetherCG_IN2}} & (In_IFM_2_buf * In_Weight_2_buf)) +
                //                 ({16{WhetherCG_IN3}} & (In_IFM_3_buf * In_Weight_3_buf)) +
                //                 ({16{WhetherCG_IN4}} & (In_IFM_4_buf * In_Weight_4_buf)) +
                //                 ({16{WhetherCG_IN5}} & (In_IFM_5_buf * In_Weight_5_buf)) +
                //                 ({16{WhetherCG_IN6}} & (In_IFM_6_buf * In_Weight_6_buf)) +
                //                 ({16{WhetherCG_IN7}} & (In_IFM_7_buf * In_Weight_7_buf)) +
                //                 ({16{WhetherCG_IN8}} & (In_IFM_8_buf * In_Weight_8_buf)) +
                //                 ({16{WhetherCG_IN9}} & (In_IFM_9_buf * In_Weight_9_buf)) ;

                // without CG
                Out_OFM_reg <=  (In_IFM_1_buf * In_Weight_1_buf) +
                            (In_IFM_2_buf * In_Weight_2_buf) +
                            (In_IFM_3_buf * In_Weight_3_buf) +
                            (In_IFM_4_buf * In_Weight_4_buf) +
                            (In_IFM_5_buf * In_Weight_5_buf) +
                            (In_IFM_6_buf * In_Weight_6_buf) +
                            (In_IFM_7_buf * In_Weight_7_buf) +
                            (In_IFM_8_buf * In_Weight_8_buf) +
                            (In_IFM_9_buf * In_Weight_9_buf) ;
            end
            default: begin
                Out_OFM_reg   <= Out_OFM_reg ;
            end
        endcase
    end
end

// Data -> Buffer  
// with clock gate 
always @(posedge clk_gate_IN1 or negedge rst_n) begin
    if (~rst_n) begin
        In_IFM_1_buf <= 0 ;
    end else begin
        In_IFM_1_buf <= (in_valid)?(In_IFM_1):(In_IFM_1_buf) ;
    end
end

always @(posedge clk_gate_IN1 or negedge rst_n) begin
    if (~rst_n) begin
        In_IFM_2_buf <= 0 ;
    end else begin
        In_IFM_2_buf <= (in_valid)?(In_IFM_2):(In_IFM_2_buf) ;
    end
end

always @(posedge clk_gate_IN1 or negedge rst_n) begin
    if (~rst_n) begin
        In_IFM_3_buf <= 0 ;
    end else begin
        In_IFM_3_buf <= (in_valid)?(In_IFM_3):(In_IFM_3_buf) ;
    end
end

always @(posedge clk_gate_IN1 or negedge rst_n) begin
    if (~rst_n) begin
        In_IFM_4_buf <= 0 ;
    end else begin
        In_IFM_4_buf <= (in_valid)?(In_IFM_4):(In_IFM_4_buf) ;
    end
end

always @(posedge clk_gate_IN1 or negedge rst_n) begin
    if (~rst_n) begin
        In_IFM_5_buf <= 0 ;
    end else begin
        In_IFM_5_buf <= (in_valid)?(In_IFM_5):(In_IFM_5_buf) ;
    end
end

always @(posedge clk_gate_IN1 or negedge rst_n) begin
    if (~rst_n) begin
        In_IFM_6_buf <= 0 ;
    end else begin
        In_IFM_6_buf <= (in_valid)?(In_IFM_6):(In_IFM_6_buf) ;
    end
end

always @(posedge clk_gate_IN1 or negedge rst_n) begin
    if (~rst_n) begin
        In_IFM_7_buf <= 0 ;
    end else begin
        In_IFM_7_buf <= (in_valid)?(In_IFM_7):(In_IFM_7_buf) ;
    end
end

always @(posedge clk_gate_IN1 or negedge rst_n) begin
    if (~rst_n) begin
        In_IFM_8_buf <= 0 ;
    end else begin
        In_IFM_8_buf <= (in_valid)?(In_IFM_8):(In_IFM_8_buf) ;	
    end
end

always @(posedge clk_gate_IN1 or negedge rst_n) begin
    if (~rst_n) begin
        In_IFM_9_buf <= 0 ;
    end else begin
        In_IFM_9_buf <= (in_valid)?(In_IFM_9):(In_IFM_9_buf) ;	
    end
end

// no clock gate 
always @(posedge clk_gate_W) begin
    // In_Weight_1_buf <= (weight_valid)?(In_Weight_1):(In_Weight_1_buf) ;
    // In_Weight_2_buf <= (weight_valid)?(In_Weight_2):(In_Weight_2_buf) ;
    // In_Weight_3_buf <= (weight_valid)?(In_Weight_3):(In_Weight_3_buf) ;
    // In_Weight_4_buf <= (weight_valid)?(In_Weight_4):(In_Weight_4_buf) ;
    // In_Weight_5_buf <= (weight_valid)?(In_Weight_5):(In_Weight_5_buf) ;
    // In_Weight_6_buf <= (weight_valid)?(In_Weight_6):(In_Weight_6_buf) ;
    // In_Weight_7_buf <= (weight_valid)?(In_Weight_7):(In_Weight_7_buf) ;
    // In_Weight_8_buf <= (weight_valid)?(In_Weight_8):(In_Weight_8_buf) ;
    // In_Weight_9_buf <= (weight_valid)?(In_Weight_9):(In_Weight_9_buf) ;
    In_Weight_1_buf <= (In_Weight_1) ;
    In_Weight_2_buf <= (In_Weight_2) ;
    In_Weight_3_buf <= (In_Weight_3) ;
    In_Weight_4_buf <= (In_Weight_4) ;
    In_Weight_5_buf <= (In_Weight_5) ;
    In_Weight_6_buf <= (In_Weight_6) ;
    In_Weight_7_buf <= (In_Weight_7) ;
    In_Weight_8_buf <= (In_Weight_8) ;
    In_Weight_9_buf <= (In_Weight_9) ;
end

// Clock Gates (ICGs)
// use ICGx3_ASAP7_75t_R
// Ports : ICGx3_ASAP7_75t_R (GCLK, ENA, SE, CLK)

// CG for In_IFM buffer 
ICGx3_ASAP7_75t_R CG_U1(
    .CLK(clk),
    .ENA(0),
    .SE(EN_IN1),
    .GCLK(clk_gate_IN1)
);

// ICGx3_ASAP7_75t_R CG_U2(
//     .CLK(clk),
//     .ENA(0),
//     .SE(EN_IN2),
//     .GCLK(clk_gate_IN2)
// );

// ICGx3_ASAP7_75t_R CG_U3(
//     .CLK(clk),
//     .ENA(0),
//     .SE(EN_IN3),
//     .GCLK(clk_gate_IN3)
// );

// ICGx3_ASAP7_75t_R CG_U4(
//     .CLK(clk),
//     .ENA(0),
//     .SE(EN_IN4),
//     .GCLK(clk_gate_IN4)
// );

// ICGx3_ASAP7_75t_R CG_U5(
//     .CLK(clk),
//     .ENA(0),
//     .SE(EN_IN5),
//     .GCLK(clk_gate_IN5)
// );

// ICGx3_ASAP7_75t_R CG_U6(
//     .CLK(clk),
//     .ENA(0),
//     .SE(EN_IN6),
//     .GCLK(clk_gate_IN6)
// );

// ICGx3_ASAP7_75t_R CG_U7(
//     .CLK(clk),
//     .ENA(0),
//     .SE(EN_IN7),
//     .GCLK(clk_gate_IN7)
// );

// ICGx3_ASAP7_75t_R CG_U8(
//     .CLK(clk),
//     .ENA(0),
//     .SE(EN_IN8),
//     .GCLK(clk_gate_IN8)
// );

// ICGx3_ASAP7_75t_R CG_U9(
//     .CLK(clk),
//     .ENA(0),
//     .SE(EN_IN9),
//     .GCLK(clk_gate_IN9)
// );

// CG for Output buffer 
ICGx3_ASAP7_75t_R CG_U10(
    .CLK(clk),
    .ENA(0),
    .SE(WhetherCG_IN1),
    .GCLK(clk_gate_OUT)
);

ICGx3_ASAP7_75t_R CG_U11(
    .CLK(clk),
    .ENA(0),
    .SE(weight_valid),
    .GCLK(clk_gate_W)
);
endmodule