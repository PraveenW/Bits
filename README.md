# Bits
Variable length Parallel to Serial Converter  
In this project we have a 32'bit parallel data input and a variable length serial data output. 
Length of output data is specified through reqlen (request length) input port. This is a 4 bit signal. So output data length can vary from 0 bits to 15 bits. A valid input data in indicated by 1 on pushin input port. A valid output data is indicated by 1 on the pushout port.  
When both read (reqin) and write (pushin)  requests are made, data is written first and then it is read. 

bits.v contains the verilog description of the design.
tbits.sv is the system verilog test-bench.
bits_gates.v is the netlist file.
IMG_9441.JPG contains the block diagram.
synthesis.script is the script used for synthesis. 
simres.txt and synres.txt are the output of simulation and synthesis.
