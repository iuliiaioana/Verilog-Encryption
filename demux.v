 `timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:12:00 11/23/2020 
// Design Name: 
// Module Name:    demux 
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

module demux #(
		parameter MST_DWIDTH = 32,
		parameter SYS_DWIDTH = 8
	)(
		// Clock and reset interface
		input clk_sys,
		input clk_mst,
		input rst_n,
		
		//Select interface
		input [1:0] select,
		
		// Input interface
		input [MST_DWIDTH -1  : 0]	 data_i,
		input 						 	 valid_i,
		
		//output interfaces
		output reg [SYS_DWIDTH - 1 : 0] 	data0_o,
		output reg     						valid0_o,
		
		output reg [SYS_DWIDTH - 1 : 0] 	data1_o,
		output reg     						valid1_o,
		
		output reg [SYS_DWIDTH - 1 : 0] 	data2_o,
		output reg     						valid2_o
    );
	
	
	// TODO: Implement DEMUX logic
	
	 reg [SYS_DWIDTH -1  : 0]  input_data[50:0][3:0];
	 reg [3:0] j=0;
	 reg [5:0] n=0;
	 reg ok=0;
	 reg [7:0] scrierea=0;
	 reg [31:0] aux;
	 
	 
	 always @(posedge clk_mst) begin
		
		if(scrierea == (n+1)*4-1) begin 
			n<=0;
			
		end
		if(valid_i==1) begin
			input_data[n][0]<=data_i[31 : 24];
			input_data[n][1]<=data_i[23 : 16];
			input_data[n][2]<=data_i[15 : 8];
			input_data[n][3]<=data_i[7 : 0];
			n<=n+1;
			
			
		end
		
	 end
	 
	 
	 
	 always @(posedge clk_sys) begin
		
			if(!rst_n) begin  //resetarea
				data0_o<=0;
				data1_o<=0;
				data2_o<=0;
				j<=0;
				scrierea<=0;
			end
		
			if(valid_i==1) begin //doresc sa incep scrierea
					
					if(scrierea>=3) begin // incep scrierea efectiva
							case(select)
								0: begin //caesar
									if(j==0) begin 
										data0_o<=data_i[31:24]; // pun direct din intrare pt primele carcatere
									end
									else begin
										data0_o<=input_data[n-1][j];
									end
									
									if(j==3) begin 
										j<=0;
									end
									else begin 
										j<=j+1;
									end
									valid0_o<=1;
								end
								
								1: begin //scytale
									if(j==0) begin 
										data1_o<=data_i[31:24];
									end
									else begin
										data1_o<=input_data[n-1][j];
									end
									
									
									if(j==3) begin 
										j<=0;
									end
									else begin
										 j<=j+1;
									end
									valid1_o<=1;
								end
								
								2: begin //zigzag
									if(j==0) begin 
										data2_o<=data_i[31:24];
									end
									else begin
										data2_o<=input_data[n-1][j];
									end
									if(j==3) begin 
										j<=0;
									end
									else begin 
										j<=j+1;
									end
								valid2_o<=1;
								end
							endcase
									
									
						scrierea<=scrierea+1;
						
						end
						else begin  // pt cand ciclu de ceas nu a ajuns la 3 si tre sa astept pt scriere 
							scrierea<=scrierea+1;
							
						end
						
			
			end	
			else if(valid_i==0 && j<=3 && scrierea>3) begin // seceventa pentru cand valid_i devine 0 si tre sa scriu carcaterele ramase 
						case(select)
							0: begin
								if(j==0) begin 
											data0_o<=data_i[31:24];
										end
										else begin
											data0_o<=input_data[n-1][j];
										end
								
								valid0_o<=1;
							end
							
							1: begin
								if(j==0) begin 
										data1_o<=data_i[31:24];
									end
									else begin
										data1_o<=input_data[n-1][j];
									end
								
								valid1_o<=1;
							end
							
							2: begin
								if(j==0) begin 
										data2_o<=data_i[31:24];
									end
									else begin
										data2_o<=input_data[n-1][j];
									end
								
								valid2_o<=1;
							end
							
						
						endcase
						j<=j+1;
						scrierea<=scrierea+1;
			end
			else begin // vreau sa ies de tot 
						data0_o<=0;
						data1_o<=0;
						data2_o<=0;
						j<=0;
						scrierea<=0;
						case(select)
							0: valid0_o<=0;
							1: valid1_o<=0;
							2: valid2_o<=0;
						endcase

						
			end
			



end
	
		
	 
	 
endmodule
