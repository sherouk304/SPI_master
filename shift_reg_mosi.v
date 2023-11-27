module shift_reg_mosi (

input   wire            i_clk             , // spi_clk
input   wire            i_rst             ,
input   wire            i_miso            ,
input   wire            i_tx_vd           ,
input   wire[2:0]       i_bit_count       ,
input   wire[2:0]       i_byte_count      ,
input   wire            i_trailing_edge   ,

output  reg [7:0]       o_rx_parallel     ,
output  reg             o_tx_device_ready

);

reg         [7:0]       q;


always @(posedge i_clk or negedge i_rst )
begin 
	if (!i_rst)
		begin  
			q  <= 'b0;
	    end 
	else if (i_trailing_edge)
		begin 
            q[0] <= i_miso;                 // whenever the data comes from slave start shifting from next cycle according to trailing edge
            q[1] <= q[0];
            q[2] <= q[1];
            q[3] <= q[2];
            q[4] <= q[3];
            q[5] <= q[4];
            q[6] <= q[5];
            q[7] <= q[6];
		end 
end 

always @(posedge i_clk or negedge i_rst )
begin 
	if (!i_rst)
		begin  
		    o_rx_parallel     <= 8'b0;      // reset values of rx_parallel and tx_ready
		    o_tx_device_ready <= 1'b0;
	    end 
	else if ((i_byte_count == 3'b111)&&(i_bit_count == 3'b111))
	    begin 
			o_rx_parallel     <= q;         // when the data is shifted 8 cycles of spi_clk, send the output and rise tx_ready flag  
			o_tx_device_ready <= 1'b1;
		end 
	else 
		begin 
	    	o_tx_device_ready <= 0;
	    end 
end 

endmodule