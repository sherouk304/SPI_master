# SPI_master
this project provides a verilog code for SPI ( serial peripheral interface ) master transceiver with basic featuers.
In this project, I assumed the clock polarity = 0 and clock phase = 1. 
the master receives parallel data (i_tx_parallel) from the device and forwards it serially to the slave (mosi "master out, slave in").
the master also receives serial data (miso "master in, slave out") from the slave and forwards it to the device in parallel (o_rx_parallel).


//////////////////////////// about the clock divider ///////////////////////////////////////////////////////////

in SPI, I divided the system clock 8 times and worked on it.
I made a signal for leading edge "o_leading_egde",its functionality is that it rises each time the clock period is on rising edge.
I made a signal for trailing edge "o_trailing_egde",its functionality is that it rises each time the clock period is on falling edge.
the signals "o_leading_egde", "o_trailing_egde" are used to synchronize the shift registers in master to shift  the data in and out the master.

///////////////////////////// about the parallel input and serial output ///////////////////////////////////////

a signal "i_tx_valid" should rise,then , after one clock cycle, it should be forced to low to ensure correct functionality.
once the signal "tx_valid" is high, the master starts reading the parallel data that comes from the device (i_tx_parallel),then , the data 
enters the shift registers and is being written into it bit by bit according to the leading edge.
then the data is out on bus bit by bit (mosi "one bit") with the leading edge and a "o_tx_slv_ready" signal is high thus it goes to the slave serially.

/////////////////////////////// about the serial input and parallel output /////////////////////////

whenever the data comes from slave (miso), it is written into the shift register with the trailing edge.
after writing all the data bits into the shift register, a "o_tx_device_ready" signal is high, and the data bits are out to the bus all in one signal with (databits) width.
