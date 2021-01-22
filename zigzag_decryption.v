`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:33:04 11/23/2020 
// Design Name: 
// Module Name:    zigzag_decryption 
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
module zigzag_decryption #(
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
			input[KEY_WIDTH - 1 : 0] key,
			
			// Output interface
			output reg[D_WIDTH - 1:0] data_o,
			output reg valid_o,
			output  reg busy=0
    );
	reg [D_WIDTH - 1:0] date_intermediare[MAX_NOF_CHARS:0]; 

	reg [2:0] l=0;
	reg [7 : 0] i=0;
	reg ok=0;
	reg [7 : 0] ckey;
	reg [7 : 0] h=0;
	
	reg [7:0] cicluri_ceas_parurse=0;
	reg [7:0] cicluri;
	reg [1:0] rest;
	reg [7:0] text=0;
	reg [7:0] index=0;;
// TODO: Implement ZigZag Decryption here
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
			
			
			case(key)
				2: begin 
					ckey<=h>>1; // impartire cu 2;
					rest<=h[0];
					
					
					if( busy==1) begin
					
							if(text<h) begin 
									valid_o<=1;
									// ne gandim ca tinem pe loc i si dupa ne bazam pe nr de ciclii si restul care poate sa fie0/1
									// tre sa scad 1 pentru ca i meu se va incrementa
									data_o<=date_intermediare[i+ckey*l+rest*l-1*l];
									l<=!l;					// ca sa pot sa am alternanta
									if( l==0) begin 
										i<=i+1;
									end
									text<=text+1;		//nunmarul de caractere afisate pana in mom actual
							end 
							else begin
								busy<=0;
								valid_o<=0;
								data_o<=0;
								i<=0;
								l<=0;
								h<=0;
								text<=0;
								
							end
						
							
								
					end
					
					
				end
				
				3: begin 
							if( busy==1) begin
						
							
							rest<=h[1:0];		// folosim ultimii 2 biti pentru ca stim ca aia sunt de
							cicluri<=h>>2; // pt key3 avem 4 elem per ciclu 
							if(text<h) begin
									valid_o<=1;
									case(rest)
										0: begin 
											case(i) //cazul fara rest 
												0: data_o<=date_intermediare[cicluri_ceas_parurse];
												1: data_o<=date_intermediare[cicluri + cicluri_ceas_parurse*2];
												2: data_o<=date_intermediare[cicluri*3 + cicluri_ceas_parurse];
												3: data_o<=date_intermediare[cicluri + cicluri_ceas_parurse*2+1];
											endcase
										
										end
										
										1: begin // adica o sa mai am un element pe primu rand
											
												case(i)
													0: data_o<=date_intermediare[cicluri_ceas_parurse];
													1: data_o<=date_intermediare[cicluri + cicluri_ceas_parurse*2+1];
													2: data_o<=date_intermediare[cicluri*3 + cicluri_ceas_parurse+1];
													3: data_o<=date_intermediare[cicluri + cicluri_ceas_parurse*2+2];
												endcase
												
										
											
										end
										
										2: begin  // o sa am si pe prima linie si pe a 2a
											
													case(i)
														0: data_o<=date_intermediare[cicluri_ceas_parurse];
														1: data_o<=date_intermediare[cicluri + cicluri_ceas_parurse*2+1];
														2: data_o<=date_intermediare[cicluri*3 + cicluri_ceas_parurse+2];
														3: data_o<=date_intermediare[cicluri + cicluri_ceas_parurse*2+2];
													endcase
													
												
										end
										
										3: begin  // o sa am si pe prima linie si pe a 2a si a 3 poz 
											
											case(i)
												0: data_o<=date_intermediare[cicluri_ceas_parurse];
												1: data_o<=date_intermediare[cicluri + cicluri_ceas_parurse*2+1];
												2: data_o<=date_intermediare[cicluri*3 + cicluri_ceas_parurse+2];
												3: data_o<=date_intermediare[cicluri + cicluri_ceas_parurse*2+2];
											
											endcase
											
											
										end
										
									
									
									endcase
									
								text<=text+1;
								if( i==3 ) begin		// cand am ajuns la ultimul elem din ciclu trebuie sa resetez 
									i<=0;
									cicluri_ceas_parurse<=cicluri_ceas_parurse+1;		// incrementez numaul de ciclii parcursi pana acum
								end else begin
									i<=i+1;	//trec la urmatorul element din ciclu
								end



							end else begin	//resetarea
								
								busy<=0;
								valid_o<=0;
								data_o<=0;
								cicluri_ceas_parurse<=0;
								i<=0;
								h<=0;
								text<=0;
							end
							
							
					end	
					
				end
			
				
				
				
			endcase
		end

endmodule
