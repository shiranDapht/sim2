// 32X32 Multiplier arithmetic unit template
module mult32x32_arith (
    input logic clk,             // Clock
    input logic reset,           // Reset
    input logic [31:0] a,        // Input a
    input logic [31:0] b,        // Input b
    input logic a_sel,           // Select one 2-byte word from A
    input logic b_sel,           // Select one 2-byte word from B
    input logic [1:0] shift_sel, // Select output from shifters
    input logic upd_prod,        // Update the product register
    input logic clr_prod,        // Clear the product register
    output logic [63:0] product  // Miltiplication product
);

	logic[63:0] product_adder_1;
	logic[63:0] product_adder_2;
	logic[63:0] shift_adder;
	logic[15:0] a_mult;
	logic[15:0] b_mult;
	logic[31:0] shift_mult;
	
	always_ff @(posedge clk, posedge reset) begin
        if (reset == 1'b1 || clr_prod == 1'b1) begin
            product <= 64'b0;
        end
        else if (upd_prod == 1'b1 ) begin
        	product <= product_adder_2;    
        end
    end
	
	always_comb begin
		
		product_adder_1 = product;

		if (a_sel == 0) begin 
			assign  a_mult = a[15:0];
		end
		else begin
			assign  a_mult = a[31:16];
		end
		
		if (b_sel == 0) begin 
			assign  b_mult = b[15:0];
		end
		else begin
			assign  b_mult = b[31:16];
		end

	    assign shift_mult = a_mult * b_mult;
		case (shift_sel) 
	    2'b00 : begin
					assign  shift_adder = shift_mult << 0; 
				end
	    2'b01 : begin
					assign  shift_adder = shift_mult << 16;
				end
	    2'b10 : begin
					assign  shift_adder = shift_mult << 32;
				end
	 
	    endcase
		
		assign  product_adder_2 =  shift_adder + product_adder_1; 

	end

endmodule
