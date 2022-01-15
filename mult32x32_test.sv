// 32X32 Multiplier test template
module mult32x32_test;

    logic clk;            // Clock
    logic reset;          // Reset
    logic start;          // Start signal
    logic [31:0] a;       // Input a
    logic [31:0] b;       // Input b
    logic busy;           // Multiplier busy indication
    logic [63:0] product; // Miltiplication product

	mult32x32  mult32x32_uut(.clk(clk), .reset(reset), .start(start), .a(a), .b(b), .busy(busy), .product(product));

	always begin
		#5 clk =~clk;
	end
	initial begin
		reset = 1'b1;
		clk = 1'b1;
		start = 1'b0;
		a = 32'b0;
		b = 32'b0;
		repeat(4) begin
			@(posedge clk);
		end
		reset = 1'b0;
		@(posedge clk);
		start = 1'b1;
		a = 316007988;
		b = 208397414;
		@(posedge clk);
		start = 1'b0;
		@(negedge busy); 

	end

endmodule
