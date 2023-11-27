//this module should recive a tx_vd signal to start working on the system clock(not spi_clk)
//this way we can using leading and trailing edge signals to manage data send and recieve

//example:
//tx valid comes >> start counter (byte count that works on on the SPI_clk) and register d_in_parallel in q register
//in the nextleading edge: shift the data to miso and inside the register
//keep shifting the data until byte_counter reaches 7\
//when byte_counter and bit_counter reaches 7(last edge of last byte) set tx_ready high

module shift_reg_miso  // multiple input, single output
 (

input 	wire  		           i_clk              ,
input 	wire                   i_rst              ,
input 	wire                   i_tx_vd            ,  
input  	wire [7:0] 	           i_tx_parallel      ,
input	wire [2:0] 	           i_bit_count        ,
input	wire [2:0]             i_byte_count       ,
input	wire		           i_leading_edge     ,
											      
output  reg  		           o_mosi             ,
output  reg                    o_tx_slv_ready
);


//internal signals and registers

reg 	[7:0]	q;
reg             start_op;


// mux selection is tx_valid falling edge (when the tx_valid falling edge occurs, Start shifting from MSB to LSB )


// always@(posedge i_clk or negedge i_rst)
	// begin 
		// if (!i_rst)  
			// start_op= 'b1;
		// else 
			// start_op= (!i_tx_vd) ? 1:0;
// end 



// mosi output reg and shift reg q[7:0]


always @(posedge i_clk or negedge i_rst )
	begin 
		if (!i_rst )
			begin 
				q      <= 8'b0;
				o_mosi <= 1'b0;
				o_tx_slv_ready <= 'b0;
			end
		else if(i_tx_vd)
			begin
				q      <= i_tx_parallel;			//load only when tx_vd is high
				o_mosi <= 1'b0;				        //and reset miso output
            end  				
		else if(i_leading_edge)
			begin 
				o_tx_slv_ready   <= 1'b1;           // tx_ready signal for slave when the data comes out 		
				{o_mosi, q[7:1]} <= q[7:0];	        //shift 0>>1 1>>2 ... 7>>miso
			end	
		else 
		    begin 
				o_tx_slv_ready <= 'b0;					
			end
 end 

endmodule