`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:24:12 11/27/2020 
// Design Name: 
// Module Name:    scytale_decryption 
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
module scytale_decryption#(
			parameter D_WIDTH = 8, 
			parameter KEY_WIDTH = 8, 
			parameter MAX_NOF_CHARS = 50,
			parameter START_DECRYPTION_TOKEN = 8'hFA
		)(
			// Clock and reset interface
			input clk,
			input rst_n,
			
			// Input interface
			input[D_WIDTH - 1:0] data_i,
			input valid_i,
			
			// Decryption Key
			input[KEY_WIDTH - 1 : 0] key_N,
			input[KEY_WIDTH - 1 : 0] key_M,
			
			// Output interface
			output reg[D_WIDTH - 1:0] data_o,
			output reg valid_o,
			
			output reg busy=0
    );

// TODO: Implement Scytale Decryption here
	reg [7 : 0] i=0;
	reg [7 : 0] j=0;
	reg [7 : 0] h=0;
	reg ok=0;
	
	reg [D_WIDTH - 1:0] date_intermediare[MAX_NOF_CHARS:0];
	

	always @(posedge clk) begin 
		if(rst_n==0) begin 
			valid_o<=0;
			data_o<=0;
		end
		
		if(valid_i==1 && data_i!=16'hFA && data_i) begin // retin datele mele intr un vector
				date_intermediare[h]<=data_i;
				h<=h+1;
				data_o<=0;
				busy<=0;
				
				
		end
		
		
		
		if (data_i==8'hFA) begin // am ajuns la final trec busy pe 1
			busy<=1;
		end
		
		
		
		
		if( busy==1) begin
		
			valid_o<=1;
			data_o<=date_intermediare[j*key_N + i]; //regula de cautare in vector
			
			
			if (j==key_M-1) begin  // daca am ajuns la finalul nr coloane 
					if(i==key_N-1) begin // ajung aici daca ajung la finalul secventei 
						ok<=1; // ca am ajuns la final pun ok pe 1
						
				
					end
					else	if(i<key_N-1) begin // tre sa schimb linia si sa resetez coloana
						i<=i+1;
						j<=0;
					end
					
			end 
			else if (j<key_M-1) begin
					j<=j+1;
					
		end
		if(ok==1) begin	// cand ajung la final am nevoie de reset
						busy<=0;
						valid_o<=0;
						data_o<=0;
						i<=0;
						j<=0;
						h<=0;
						ok<=0;
		end
		
		
	end
	end

endmodule
