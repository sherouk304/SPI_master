module spi_master (

input  wire               sys_clk                ,
input  wire               sys_rst                ,
input  wire               i_miso                 ,
input  wire               i_tx_vd                ,
input  wire               i_clk_pol              ,
input  wire  [7:0]        i_tx_parallel          ,
											     
output wire  [7:0]        o_rx_parallel          ,
output wire               o_mosi                 ,
output wire               o_spi_clk              , 
output wire               o_tx_slv_ready         ,
output wire               o_tx_device_ready      ,
output wire               o_leading_edge         , 
output wire               o_trailing_edge        ,
output wire   [2:0]       o_bit_count            ,
output wire   [2:0]       o_byte_count


);

clk_divider U1 (

.i_clk           (sys_clk             )          , 
.i_rst           (sys_rst             )          , 
.i_tx_vd         (i_tx_vd             )          , 
.i_clk_pol       (i_clk_pol           )          , 
.o_clk           (o_spi_clk           )          , 
.o_leading_edge  (o_leading_edge      )          ,
.o_trailing_edge (o_trailing_edge     )          , 
.o_bit_count     (o_bit_count         )          , 
.o_byte_count    (o_byte_count        )           
                                            
);                                          
                                            
shift_reg_miso U2 (  
                       
.i_clk           (sys_clk	          )          ,    
.i_rst           (sys_rst             )          ,
.i_tx_vd         (i_tx_vd             )          ,
.i_tx_parallel   (i_tx_parallel       )          ,
.i_bit_count     (o_bit_count         )          ,
.i_byte_count    (o_byte_count        )          ,
.i_leading_edge  (o_leading_edge      )          ,			      
.o_mosi          (o_mosi              )          ,
.o_tx_slv_ready  (o_tx_slv_ready      )
);

shift_reg_mosi U3 (

.i_clk            (sys_clk            )          ,
.i_rst            (sys_rst            )          ,
.i_miso           (i_miso             )          ,
.i_tx_vd          (i_tx_vd            )          ,
.i_byte_count     (o_byte_count       )          ,
.i_bit_count      (o_bit_count        )          ,
.i_trailing_edge  (o_trailing_edge    )          ,
.o_rx_parallel    (o_rx_parallel      )          ,
.o_tx_device_ready(o_tx_device_ready  )
                 

);

endmodule