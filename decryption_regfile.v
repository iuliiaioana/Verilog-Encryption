`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:13:49 11/23/2020 
// Design Name: 
// Module Name:    decryption_regfile 
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
module decryption_regfile #(
			parameter addr_witdth = 8,
			parameter reg_width 	 = 16
		)(
			// Clock and reset interface
			input clk, 
			input rst_n,
			
			// Register access interface
			input[addr_witdth - 1:0] addr,
			input read,
			input write,
			input [reg_width -1 : 0] wdata,
			output reg [reg_width -1 : 0] rdata,
			output reg done,
			output reg error,
			
			// Output wires
			output [reg_width - 1 : 0] select,
			output [reg_width - 1 : 0] caesar_key,
			output [reg_width - 1 : 0] scytale_key,
			output [reg_width - 1 : 0] zigzag_key
	
    );
	

// TODO implementati bancul de registre.


	reg [reg_width-1:0] select_register;
	reg [reg_width-1:0] caesar_register;
	reg [reg_width-1:0] scytale_register;
	reg [reg_width-1:0] zigzag_register;
	


	always @(posedge clk ) begin
	
		if(rst_n==0) begin
		
			  select_register <= 16'h0;
			  caesar_register <=16'h0;
			  scytale_register <=16'hffff;
			  zigzag_register <=16'h2;
			  
		end 
			else	begin	
			if (write==1) begin
						done<=1;
						if(addr==16'h0) begin
						
							select_register[1]<=wdata[1];
							select_register[0]<=wdata[0];
							
							error<=0;
						end 
						else if( addr== 16'h10) begin
							caesar_register<=wdata;
							
							error<=0;
						end 
						else if(addr==16'h12) begin
							scytale_register<=wdata;
							
							error<=0;
						end
						else if(addr==16'h14) begin
							zigzag_register<=wdata;
							
							error<=0;
						end 
						else begin
							error<=1;
					
						end
					
			end			
			else if (read==1) begin
		
					if(addr==16'h0) begin
						rdata<=select_register;
						done<=1;
						error<=0;
					end 
					else if(addr==16'h10) begin
						rdata<=caesar_register;
						done<=1;
						error<=0;
					end 
					else if(addr==16'h12) begin
						rdata<=scytale_register;
						done<=1;
						error<=0;
					end 
					else if(addr==16'h14) begin
						rdata<=zigzag_register;
						done<=1;
						error<=0;
					end 
					else begin
						error<=1;
						done<=1;
						rdata<=0;
						
					end
										

			end 
			else  begin 
					done<=0;
					error<=0;
			end
			
			
				
		end

	end
			

		
		
		assign select = select_register;
		assign caesar_key= caesar_register;
		assign scytale_key=scytale_register;
		assign zigzag_key= zigzag_register;
		
		
		
		

	
	endmodule
