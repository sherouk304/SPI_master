

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:17:34 10/22/2023 
// Design Name: 
// Module Name:    clk_divider 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//

//////////////////////////////////////////////////////////////////////////////////
module clk_divider(
 
input  wire                   i_clk,
input  wire                   i_rst,
input  wire                   i_tx_vd,
input  wire                   i_clk_pol,

output wire                   o_clk,
output reg                    o_leading_edge,
output reg                    o_trailing_edge,
output reg   [2:0]            o_bit_count,
output reg   [2:0]            o_byte_count
    );


// internal wires 

reg                           o_spi_clk;
reg                           start_capture_clk;

// bit counter 


always @(posedge i_clk or negedge i_rst )
  begin 
        if (!i_rst )
		begin
	        o_bit_count<='b0;
            start_capture_clk <= 1'b0;			
		end

	    else if (i_tx_vd )
	        o_bit_count<='b0;
	    else
			begin
                start_capture_clk <= 1'b1;			
		        o_bit_count <= o_bit_count +1;
	        end 
  end 
  
  
  
  // byte counter
  
  always @(posedge i_clk or negedge i_rst )
    begin 
        if (!i_rst )
  	        o_byte_count<='b0;
  	    else if (o_bit_count == 'b111)  
  		    o_byte_count <= o_byte_count +1;
  	    else   
            o_byte_count <= o_byte_count ;
    end 

  
// leading and trailing 

  
always @(posedge i_clk or negedge i_rst)
	begin
		if (!i_rst)
			begin
				o_trailing_edge<= 1'b0;
			end 
		else if (o_bit_count == 3'b110)
		    begin 
				o_trailing_edge<= 1'b1;
			end 
        else 
            begin 
				o_trailing_edge<= 1'b0;
            end 			
	end 
  
always @(posedge i_clk or negedge i_rst)
	begin
		if (!i_rst)
			begin
				o_leading_edge <= 1'b0;
			end 
		else if (o_bit_count == 3'b010)
		    begin 
				o_leading_edge <= 1'b1;
			end 
        else
            begin 
				o_leading_edge <= 1'b0;
            end 			
	end 
  
//o_clk signal 


// spi_clk generation   
  
  
  always @(posedge i_clk or negedge i_rst)
   begin 
        if (!i_rst)
		begin 
		        o_spi_clk <='b0;
	    end 
	    else if(o_bit_count == 'b011 )
			begin 
			    o_spi_clk <= ! o_spi_clk; 
            end 
		else if(o_bit_count == 'b111)
		    begin
			    o_spi_clk <= ! o_spi_clk;
			end 
        else  
           begin   
                o_spi_clk <= o_spi_clk;				
           end		   
	end  


assign o_clk = (i_clk_pol & start_capture_clk)? o_spi_clk: !o_spi_clk;
  
endmodule
