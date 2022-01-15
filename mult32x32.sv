// 32X32 Iterative Multiplier template
module mult32x32 (
    input logic clk,            // Clock
    input logic reset,          // Reset
    input logic start,          // Start signal
    input logic [31:0] a,       // Input a
    input logic [31:0] b,       // Input b
    output logic busy,          // Multiplier busy indication
    output logic [63:0] product // Miltiplication product
);
    logic upd_prod;
    logic clr_prod;
    logic [1:0] sel_shift;
	logic sel_1;
    logic sel_2;

	mult32x32_arith ARITH (.clk(clk), .reset(reset),.a(a),.b(b), .sel_1(sel_1),.sel_2(sel_2),.sel_shift(sel_shift),.upd_prod(upd_prod),.clr_prod(clr_prod),.product(product));
	mult32x32_fsm FSM (.clk(clk), .reset(reset), .start(start),.busy(busy),.sel_1(sel_1),.sel_2(sel_2),.sel_shift(sel_shift),.upd_prod(upd_prod),.clr_prod(clr_prod));
	
endmodule
