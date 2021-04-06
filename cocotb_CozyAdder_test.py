import random
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import FallingEdge
from cocotb.triggers import RisingEdge
from cocotb.triggers import Timer
from cocotb.binary import BinaryValue
from helper import int_list_to_bitstream
from helper import bin_list_to_int_little_endian
from helper import int_to_bin_list_little_endian
import os

@cocotb.test()
async def test_fpga_core(dut):
	clock = Clock(dut.scan_clk, 10, units="ns")
	cocotb.fork(clock.start())

	# 2 * 2 fpga
	# built for primary fpga functional test because bitstream generator is pending complete
	# bitstream used in this testbench is hand-translated from VTR result

	# io info:
	# io_0: C, io_1: B, io_2: A, io_3: D
	# C = A | B, D = A & B
	tile_2_A_port = 0
	tile_3_A_port = 0
	tile_2_B_port = 2
	tile_3_B_port = 2

	# The Environmental Variable BITSTREAM_DIR is set in the vtr_wholeflow.sh
	# Loading Routing Configuration Bitstream
	import re
	f = open(os.getenv('BITSTREAM_ROUTE_PATH'), "r")
	routing = f.read()
	routing = re.split("\n", routing)
	routing = [int(i) for i in routing if len(i) > 0]
	f.close()
	conn_bitstream = int_list_to_bitstream(routing, 2)
	conn_scan_size = len(conn_bitstream)
	
	conn_bitstream_check = conn_bitstream.copy()
	conn_bitstream += conn_bitstream_check
  	
	# Loading CLB Configuration Bitstream
	# The Environmental Variable BITSTREAM_DIR is set in the vtr_wholeflow.sh
	f = open(os.getenv('BITSTREAM_CLB_PATH'), "r")
	lut_bitstream = f.read()
	lut_bitstream = [int(i) for i in lut_bitstream]
	f.close()
	lut_scan_size = len(lut_bitstream)
	
	lut_bitstream_check = lut_bitstream.copy()
	lut_bitstream += lut_bitstream_check
	
	# print("lut bitstream:")
	# print(lut_bitstream)
	# print("conn bitstream:")
	# print(conn_bitstream)
	
	#first scan 
	dut.clb_scan_en <= 1
	for i in range(lut_scan_size):
		dut.clb_scan_in <= lut_bitstream.pop(-1)
		await RisingEdge(dut.scan_clk)
	dut.clb_scan_en <= 0
	
	
	dut.conn_scan_en <= 1
	for i in range(conn_scan_size):
		dut.conn_scan_in <= conn_bitstream.pop(-1)
		await RisingEdge(dut.scan_clk)
		await Timer(1, units='ns')
	dut.conn_scan_en <= 0
	
	#repeated scan and check
	clb_scan_out = []
	dut.clb_scan_en <= 1
	for i in range(lut_scan_size):
		dut.clb_scan_in <= lut_bitstream.pop(-1)
		await RisingEdge(dut.scan_clk)
		clb_scan_out.append(dut.clb_scan_out.value)
	dut.clb_scan_en <= 0
	
	if(lut_bitstream_check == clb_scan_out[::-1]):
		print('clb bitstream valid')
	else:
		print('clb bitstream invalid')
		
	conn_scan_out = []
	dut.conn_scan_en <= 1
	for i in range(conn_scan_size):
		dut.conn_scan_in <= conn_bitstream.pop(-1)
		await RisingEdge(dut.scan_clk)
		conn_scan_out.append(dut.conn_scan_out.value)
	dut.conn_scan_en <= 0
	
	if(conn_bitstream_check == conn_scan_out[::-1]):
		print('conn bitstream valid')
	else:
		print('conn bitstream invalid')
	
	print("Adder test")
	for n in range(20):
		#b1
		b1 = random.randint(0,1)
		b0 = random.randint(0,1)
		a1 = random.randint(0,1)
		a0 = random.randint(0,1)
		dut.fpga_in[1] <= b1
		#b0
		dut.fpga_in[3] <= b0	
		#a1
		dut.fpga_in[2] <= a1
		#a0
		dut.fpga_in[4] <= a0
		await Timer(100, units='ns')
		print('b=',b1*2+b0,'(',b1,b0,')','a=',a1*2+a0,'(',a1,a0,')',
		'sum=',dut.fpga_out[0].value*4+dut.fpga_out[5].value*2+dut.fpga_out[6].value,
		'(',dut.fpga_out[0].value,dut.fpga_out[5].value,dut.fpga_out[6].value,')')
		
	await Timer(1000, units='ns')
	
