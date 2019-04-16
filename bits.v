`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  San Jose State University
// Engineer: Praveen Waliitagi	
// 
// Create Date:    03:50:18 02/23/2015 
// Design Name: Variable Parallel to Serial Converter
// Module Name:    bits
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
module bits(
input clk,
input rst,
input pushin,
input [31:0] datain,
input reqin,
input [3:0] reqlen,
output pushout,
output [3:0] lenout,
output [14:0] dataout
);

reg [1023 : 0] mem_data1;
reg [9:0] wr_ptr;
wire empty;

reg pushin0;
reg reqin0;
reg [3:0] lenin0;
reg [31:0] datain0;


assign empty = (wr_ptr == 10'd992);

always @(posedge clk or posedge rst)
begin
if(rst)
begin
pushin0 <= #1 0;
reqin0 <= #1 0;
lenin0 <= #1 4'd0;
datain0 <= #1 32'd0;
end
else
begin
pushin0 <= #1 pushin;
reqin0 <= #1 reqin;
lenin0 <= #1 reqlen;
datain0 <= #1 datain;
  end
end

reg [14:0] dataout_reg1,dataout_reg2;
reg pushout_reg;
reg [14:0] temp_data;


always @(posedge clk or posedge rst)
begin
if(rst)
begin
wr_ptr <= #1 10'd992;
mem_data1 <= #1 1024'd0;
dataout_reg1 <= #1 15'd0;
pushout_reg <= #1 0;
end
//------------------------------------------------------

else
begin
if(pushin0 && (!reqin0))
begin
mem_data1 <= #1 (mem_data1 ^ ({datain0,992'd0} >> wr_ptr));
wr_ptr <= #1 (wr_ptr - 10'd32);
pushout_reg <= #1 0;
$display ("%d : I have only pushin0 and no reqin0 \n", $time);

end

//--------------------------------------------------------

else if(reqin0 && (!pushin0)) 
begin
dataout_reg1 <= #1 mem_data1[14:0];
mem_data1 <= #1 (mem_data1 >> lenin0);
pushout_reg <= #1 1;
wr_ptr <= #1 (wr_ptr + lenin0);

$display ("%d : I have only reqin0 and no pushin0 \n", $time); //Display statement is added for debugging RTL sims
end

//--------------------------------------------------------

else if( pushin0 && reqin0  && (!empty) ) 
begin
mem_data1 <= #1 ((mem_data1 ^ ({datain0,992'd0} >> wr_ptr)) >> lenin0); //lenin0 shifting is for read being done in same cycle
dataout_reg1 <= #1 (mem_data1 ^ ({datain0,992'd0} >> wr_ptr)); //this will truncate all bits except 15 bits this is done because we need to write before we read.
  wr_ptr <= #1 (wr_ptr + lenin0 - 10'd32);
pushout_reg <= #1 1;
$display ("%d : I have both reqin0 and pushin0 but I'm not empty \n", $time); 


end

//----------------------------------------------------------

else if( pushin0 && reqin0  && (empty) && (lenin0 == 4'd0) )
begin
mem_data1 <= #1 ((mem_data1 ^ ({datain0,992'd0} >> wr_ptr)) >> lenin0); //lenin0 shifting is for read being done in same cycle
//dataout_reg1 <= #1 (mem_data1 ^ ({datain0,992'd0} >> wr_ptr)); //this will truncate all bits except 15 bits this is done because we need to write before we read.
dataout_reg1 <= #1 mem_data1[14:0];
wr_ptr <= #1 (wr_ptr + lenin0 - 10'd32);
pushout_reg <= #1 1;
$display ("%d : I have both reqin0 and pushin0 and I'm empty and lenino=4'd0  \n",$time);

end

else
begin
mem_data1 <= #1 mem_data1;
wr_ptr <= #1 wr_ptr;
dataout_reg1 <= #1 15'b0;
pushout_reg <= #1 0;
$display ("%d : I'm the else part \n", $time);


end
end
end


reg [3:0] lenin01;

always @(*)
begin
temp_data = 15'b0;
dataout_reg2 = 15'b0;
if(pushout_reg)
begin
temp_data = ~(15'h7fff << lenin01);
dataout_reg2 = temp_data & dataout_reg1;
end
end


assign dataout =  dataout_reg2;
assign lenout =  lenin01;
assign pushout =  pushout_reg;

always @(posedge clk or posedge rst)
begin
if(rst)
lenin01 <= #1 4'd0;
else
lenin01 <= #1 lenin0;
end




endmodule
