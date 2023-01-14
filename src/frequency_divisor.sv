module frequency_divisor #(parameter ONE_SECOND = 1, NBITS = 1)(_rst, clk, switch_1, switch_2, switch_3, new_clk, led_clk_1, led_clk_2, led_clk_3);
  
  input logic clk, _rst, switch_1, switch_2, switch_3;
  output logic new_clk, led_clk_1, led_clk_2, led_clk_3;
  logic clk_desejado;
  logic [NBITS - 1:0] counter;
  
  enum {CLK_1, CLK_20, CLK_60, OFF} clks;
  
  always_ff @(posedge clk or negedge _rst)
  begin
    if(!_rst)
      begin
		  new_clk <= 1'b0;
        counter = 1'b0;
      end
    else begin
       
		 if(switch_1 == 1'b1 && switch_2 == 1'b0 && switch_3 == 1'b0) begin 
			clks <= CLK_1;
			led_clk_1 <= 1'b1;
			led_clk_2 <= 1'b0;
			led_clk_3 <= 1'b0;
		 end else if(switch_2 == 1'b1 && switch_1 == 1'b0 && switch_3 == 1'b0) begin
		   clks <= CLK_20;
			led_clk_1 <= 1'b0;
			led_clk_2 <= 1'b1;
			led_clk_3 <= 1'b0;
		 end else if(switch_3 == 1'b1 && switch_1 == 1'b0 && switch_2 == 1'b0) begin
		   clks <= CLK_60;
			led_clk_1 <= 1'b0;
			led_clk_2 <= 1'b0;
			led_clk_3 <= 1'b1;
		 end else if(switch_1 == 1'b0 && switch_2 == 1'b0 && switch_3 == 1'b0) begin
			clks <= OFF;
			led_clk_1 <= 1'b0;
			led_clk_2 <= 1'b0;
			led_clk_3 <= 1'b0;
		 end
      
		 unique case (clks)
			CLK_1: begin
			  if(counter == ONE_SECOND) begin
					new_clk <= 1'b1;
					counter = 1'b0;
			  end else begin
					new_clk <= 1'b0;
					counter++;
			  end
			end
			CLK_20: begin
			  if(counter == (ONE_SECOND/20)) begin
					new_clk <= 1'b1;
					counter =1'b0;
			  end else begin
					new_clk = 1'b0;
					counter++;
			  end
			end
			CLK_60: begin
			  if(counter == (ONE_SECOND/60)) begin
					new_clk <= 1'b1;
					counter =1'b0;
			  end else begin
					new_clk <= 1'b0;
					counter++;
			  end
			end
			OFF: begin
				new_clk <= 1'b0;
				counter = 1'b0;
			end
		 endcase
	  end
  end
  
endmodule  
  
  
