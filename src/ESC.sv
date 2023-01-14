module ESC(_rst, clk, switch_1, switch_2, switch_3, bobina_A, bobina_B, bobina_C);
	input logic _rst, clk, switch_1, switch_2, switch_3;
	output logic bobina_A, bobina_B, bobina_C;
	
	logic [2:0] counter;
	logic motor_aceleration;
	enum {OFF, BOBINA_AB, BOBINA_A, BOBINA_AC, BOBINA_C, BOBINA_BC, BOBINA_B} estados_bobinas;
	
	frequency_divisor #(49999999, 32) fd(._rst(_rst), .clk(clk), .switch_1(switch_1), .switch_2(switch_2), .switch_3(switch_3), .new_clk(motor_aceleration));

	always_ff @(posedge motor_aceleration or negedge _rst) 
		begin
			if(!_rst) begin
				counter = 1'b0;
			end else if(counter >= 3'b110) begin
				counter = 1'b1;
			end else begin
				counter++;
			end
		end
	
	always_ff @(posedge motor_aceleration or negedge _rst)
		begin
			if(!_rst) begin
				estados_bobinas <= OFF;
			end else begin			
				unique case(counter)
					1'b1 : estados_bobinas <= BOBINA_AB;
					2'b10 : estados_bobinas <= BOBINA_A;
					2'b11 : estados_bobinas <= BOBINA_AC;
					3'b100 : estados_bobinas <= BOBINA_C;
					3'b101 : estados_bobinas <= BOBINA_BC;
					3'b110 : estados_bobinas <= BOBINA_B;
				endcase
			end
		end
	
	always_comb
		begin
			unique case(estados_bobinas)
				OFF : begin
						bobina_A <= 1'b0;
						bobina_B <= 1'b0;
						bobina_C <= 1'b0;
				end
				BOBINA_AB : begin
						bobina_A <= 1'b1;
						bobina_B <= 1'b1;
						bobina_C <= 1'b0;
				end
				BOBINA_A : begin
						bobina_A <= 1'b1;
						bobina_B <= 1'b0;
						bobina_C <= 1'b0;
				end
				BOBINA_AC : begin
						bobina_A <= 1'b1;
						bobina_B <= 1'b0;
						bobina_C <= 1'b1;
				end
				BOBINA_C : begin
						bobina_A <= 1'b0;
						bobina_B <= 1'b0;
						bobina_C <= 1'b1;
				end
				BOBINA_BC : begin
						bobina_A <= 1'b0;
						bobina_B <= 1'b1;
						bobina_C <= 1'b1;
				end
				BOBINA_B : begin
						bobina_A <= 1'b0;
						bobina_B <= 1'b1;
						bobina_C <= 1'b0;
				end
			endcase
		end
		
endmodule : ESC