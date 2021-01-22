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

module decryption_top#(
			parameter addr_witdth = 8,
			parameter reg_width 	 = 16,
			parameter MST_DWIDTH = 32,
			parameter SYS_DWIDTH = 8
		)(
		// Clock and reset interface
		input clk_sys,
		input clk_mst,
		input rst_n,
		
		// Input interface
		input [MST_DWIDTH -1 : 0] data_i,
		input 						  valid_i,
		output busy,
		
		//output interface
		output [SYS_DWIDTH - 1 : 0] data_o,
		output      					 valid_o,
		
		// Register access interface
		input[addr_witdth - 1:0] addr,
		input read,
		input write,
		input [reg_width - 1 : 0] wdata,
		output[reg_width - 1 : 0] rdata,
		output done,
		output error
		
    );
	 wire busy0; 
	 wire busy1;
	 wire busy2;
	 wire [reg_width - 1 : 0] select;
	 wire [reg_width - 1 : 0] caesar_key;
	 wire [reg_width - 1 : 0] scytale_key;
	 wire [reg_width - 1 : 0] zigzag_key;
	 
	 
	wire [SYS_DWIDTH - 1 : 0] 	data0_o;
	wire     						valid0_o;
		
	wire [SYS_DWIDTH - 1 : 0] 	data1_o;
	wire     						valid1_o;
		
	wire [SYS_DWIDTH - 1 : 0] 	data2_o;
	wire     						valid2_o;
	
	
	
	wire [SYS_DWIDTH - 1 : 0] 	data0_i;
	wire     						valid0_i;
		
	wire [SYS_DWIDTH - 1 : 0] 	data1_i;
	wire     						valid1_i;
		
	wire [SYS_DWIDTH - 1 : 0] 	data2_i;
	wire     						valid2_i;
	 // doresc intantierea modulelor, ordinea aferenta graficului 
	wire [1:0] select_bun;
	

	decryption_regfile inst(clk_sys, rst_n, addr, read, write, wdata, rdata, done, error, select, caesar_key, scytale_key, zigzag_key);
	assign select_bun=select[1:0];

	demux inst_demux(clk_sys, clk_mst, rst_n, select_bun, data_i,valid_i,         data0_i, valid0_i,          data1_i,valid1_i,      data2_i,valid2_i);
	

	caesar_decryption inst_caesar(clk_sys, rst_n,  data0_i,valid0_i , caesar_key, data0_o, valid0_o, busy0);
	
	
	

	scytale_decryption inst_scytale(clk_sys, rst_n,   data1_i,valid1_i,        scytale_key[15:8],scytale_key[7:0],     data1_o, valid1_o, busy1);
	
	
	
	
	zigzag_decryption inst_zigzag(clk_sys,  rst_n,  data2_i,valid2_i,       zigzag_key[7:0],          data2_o, valid2_o,         busy2);
	 
	 
	assign busy = busy0 || busy1 || busy2; 
	mux inst_mux(clk_sys, rst_n, select_bun, data_o, valid_o, data0_o, valid0_o, data1_o, valid1_o, data2_o, valid2_o);
	 
	 
	

endmodule
