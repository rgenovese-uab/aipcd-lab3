// This file manualy created 
module RGB2YCrCb (
	input clk,
	input  reset,
	input  enable,
	input [31:0] ctrl,
	input [31:0] data0,
	input [31:0] data1,
	input [31:0] alu_result,
	output [31:0] result,
	output reg done);

wire [7:0] r;
wire [7:0] b;
wire [7:0] g;

reg [7:0] y;
reg [7:0] cr;
reg [7:0] cb;

wire [7:0] zero8;

assign r = data0[23:16];
assign g = data0[15:8];
assign b = data0[7:0];

always @(posedge clk) begin
	if(reset) begin
		y  <= 0;
		cr <= 0;
		cb <= 0;
	end else begin
		y  <= (19595 * r + 38470 * g + 7471 * b) >> 16;
		cr <= 128 + ((-11059 * r - 21610 * g + 32768 * b) >> 16);
		cb <= 128 + ((32768 * r - 27439 * g - 5329 * b) >> 16);
	end
end

assign zero8[7:0] = 0;
assign result ={zero8, y, cr, cb};


always @(posedge clk)
    if (reset == 1)
       done <= 0;
    else
       done <= enable;

endmodule


