


`timescale 1ns/1ps
module testbench;

reg                sys_clk           ;
reg                sys_rst           ;
reg                i_miso            ;
reg                i_tx_vd           ;
reg                i_clk_pol         ;
reg   [7:0]        i_tx_parallel     ;
									 
wire  [7:0]        o_rx_parallel     ;
wire               o_mosi            ;
wire               o_spi_clk         ;
wire               o_tx_slv_ready    ;
wire               o_tx_device_ready ;
wire               o_leading_edge    ;
wire               o_trailing_edge   ;
wire   [2:0]       o_bit_count       ;
wire   [2:0]       o_byte_count      ;


initial begin
	$dumpfile("testbench9.vcd");
	$dumpvars;

            sys_clk = 1'b1;              
            sys_rst = 1'b0;        
            i_miso  = 1'b0;        
            i_tx_vd = 1'b0;        
            i_clk_pol = 1'b1;   	
            i_tx_parallel= 8'b0000_0000;   
		#2
            i_tx_vd =1'b0;
		    sys_rst =1'b1;
		    i_tx_parallel =8'b1010_1010;
		    i_miso  = 1'b1;
		#8	
			//first miso
			i_tx_vd =1'b1;
			i_miso  = 1'b1;
			
		#(10)		
			i_tx_vd =1'b0;		
			i_miso  = 1'b0;
		#(10*8)		
				
			i_miso  = 1'b1;			

		#(10*8)		
				
			i_miso  = 1'b0;

		#(10*8)		
				
			i_miso  = 1'b1;			


		#(10*8)		
				
			i_miso  = 1'b0;



		#(10*8)		
				
			i_miso  = 1'b1;


		#(10*8)		
				
			i_miso  = 1'b0;


			
        #(8*3*10)
		
		$stop;
     
      
end

always #5 sys_clk = !sys_clk;

spi_master DUT
(
.sys_clk             (sys_clk               )   ,
.sys_rst             (sys_rst               )   ,
.i_miso              (i_miso                )   ,
.i_tx_vd             (i_tx_vd               )   ,
.i_clk_pol           (i_clk_pol             )   ,
.i_tx_parallel       (i_tx_parallel         )   ,     
.o_rx_parallel       (o_rx_parallel         )   ,
.o_mosi              (o_mosi                )   ,
.o_spi_clk           (o_spi_clk             )   ,
.o_tx_slv_ready      (o_tx_slv_ready        )   ,
.o_tx_device_ready   (o_tx_device_ready     )   ,
.o_leading_edge      (o_leading_edge        )   ,
.o_trailing_edge     (o_trailing_edge       )   ,
.o_bit_count         (o_bit_count           )   ,
.o_byte_count        (o_byte_count          )
                     
);                   
                     

endmodule 
