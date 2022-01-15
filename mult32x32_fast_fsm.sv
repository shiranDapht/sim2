// 32X32 Multiplier FSM
module mult32x32_fast_fsm (
    input logic clk,              // Clock
    input logic reset,            // Reset
    input logic start,            // Start signal
    input logic a_msw_is_0,       // Indicates MSW of operand A is 0
    input logic b_msw_is_0,       // Indicates MSW of operand B is 0
    output logic busy,            // Multiplier busy indication
    output logic a_sel,           // Select one 2-byte word from A
    output logic b_sel,           // Select one 2-byte word from B
    output logic [1:0] shift_sel, // Select output from shifters
    output logic upd_prod,        // Update the product register
    output logic clr_prod         // Clear the product register
);

	typedef enum { idle, s_1, s_2, s_3, s_4 } s_type;
	
	s_type current;
    s_type next;

	always_ff @(posedge clk, posedge reset) begin
        if (reset == 1'b1) begin
            current <= idle;
        end
        else begin
            current <= next;
        end
    end
	
	always_comb begin
	upd_prod = 1'b0;
	clr_prod = 1'b0;
	busy = 1'b0;
	shift_sel = 2'b0;
	a_sel = 1'b0;
	b_sel = 1'b0;
	next = current;
    case (current)
        idle: begin
            if (start == 1) begin
				clr_prod = 1'b1;
                next = s_1;
            end
        end
        s_1: begin
			if(a_msw_is_0 == 1 && b_msw_is_0 == 1)begin
				upd_prod = 1'b1;
				busy = 1'b1;
				next = idle;
            end
			else if(a_msw_is_0 == 1 && b_msw_is_0 == 0)begin
				upd_prod = 1'b1;
				busy = 1'b1;
				next = s_3;
            end
            else begin 
				upd_prod = 1'b1;
				busy = 1'b1;
				next = s_2;
			end
        end
		s_2: begin
			if(a_msw_is_0== 0 && b_msw_is_0== 1)begin
				upd_prod = 1'b1;
				busy = 1'b1;
				shift_sel = 2'b01;
				a_sel = 1'b1;
				b_sel = 1'b0;
				next = idle;
            end
			else begin
				upd_prod = 1'b1;	
				busy = 1'b1;
				shift_sel = 2'b01;
				a_sel = 1'b1;
				b_sel = 1'b0;
				next = s_3;
			end
        end
		s_3: begin
			if(a_msw_is_0 == 1 && b_msw_is_0 == 0)begin
				upd_prod = 1'b1;
				busy = 1'b1;
				shift_sel = 2'b01;
				a_sel = 1'b0;
				b_sel = 1'b1;
				next = idle;
            end
			else begin
				upd_prod = 1'b1;
				busy = 1'b1;
				shift_sel = 2'b01;
				a_sel = 1'b0;
				b_sel = 1'b1;
				next = s_4;
			end
        end
		s_4: begin
			upd_prod = 1'b1;
			busy = 1'b1;
			shift_sel = 2'b10;	
			a_sel = 1'b1;
			b_sel = 1'b1;
            next = idle;
        end
    endcase
end

endmodule
