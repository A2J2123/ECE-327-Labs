/***************************************************/
/* ECE 327: Digital Hardware Systems - Spring 2025 */
/* Lab 4                                           */
/* Matrix Vector Multiplication (MVM) Module       */
/***************************************************/

module mvm # (
    parameter IWIDTH = 8,
    parameter OWIDTH = 32,
    parameter MEM_DATAW = IWIDTH * 8,
    parameter VEC_MEM_DEPTH = 256,
    parameter VEC_ADDRW = $clog2(VEC_MEM_DEPTH),
    parameter MAT_MEM_DEPTH = 512,
    parameter MAT_ADDRW = $clog2(MAT_MEM_DEPTH),
    parameter NUM_OLANES = 8
)(
    input clk,
    input rst,
    input [MEM_DATAW-1:0] i_vec_wdata,
    input [VEC_ADDRW-1:0] i_vec_waddr,
    input i_vec_wen,
    input [MEM_DATAW-1:0] i_mat_wdata,
    input [MAT_ADDRW-1:0] i_mat_waddr,
    input [NUM_OLANES-1:0] i_mat_wen,
    input i_start,
    input [VEC_ADDRW-1:0] i_vec_start_addr,
    input [VEC_ADDRW:0] i_vec_num_words,
    input [MAT_ADDRW-1:0] i_mat_start_addr,
    input [MAT_ADDRW:0] i_mat_num_rows_per_olane,
    output o_busy,
    output [OWIDTH-1:0] o_result [0:NUM_OLANES-1],
    output o_valid
);

/******* Your code starts here *******/
// Vector Memory Wires
logic [VEC_ADDRW-1:0] r_vec_raddr;
logic [MEM_DATAW-1:0] r_vec_rdata;

// Matrix Memory Wires
logic [MAT_ADDRW-1:0] r_mat_raddr;
logic [MEM_DATAW-1:0] r_mat_rdata [0:NUM_OLANES-1];

// Dot Product Unit Wires
logic r_ovalid;
logic r_dot_ovalid [0:NUM_OLANES-1];
logic [OWIDTH-1:0] r_dot_result [0:NUM_OLANES-1];

// Accumulator Wires
logic r_first;
logic r_last;


// Vector Memory Instantiation
mem # (.DATAW(MEM_DATAW), .DEPTH(VEC_MEM_DEPTH)) vector (
    .clk(clk),
    .wdata(i_vec_wdata),
    .waddr(i_vec_waddr),
    .wen(i_vec_wen),
    .raddr(r_vec_raddr),
    .rdata(r_vec_rdata)
);

// Generate for Output Lanes Instantiation
genvar x;
generate
for (x = 0; x < NUM_OLANES; x = x + 1) begin : olanes
    // Matrix Memories
    mem # (.DATAW(MEM_DATAW), .DEPTH(MAT_MEM_DEPTH)) matrix (
        .clk(clk),
        .wdata(i_mat_wdata),
        .waddr(i_mat_waddr),
        .wen(i_mat_wen[x]),
        .raddr(r_mat_raddr),
        .rdata(r_mat_rdata[x])
    );
    
    // Dot Product Units
    dot8 # (.IWIDTH(IWIDTH), .OWIDTH(OWIDTH)) dot8_unit (
        .clk(clk),
        .rst(rst),
        .vec0(r_vec_rdata),
        .vec1(r_mat_rdata[x]),
        .ivalid(r_ovalid),
        .result(r_dot_result[x]),
        .ovalid(r_dot_ovalid[x])
    );
    
    // Accumulator
    accum #(.DATAW(OWIDTH), .ACCUMW(OWIDTH)) accum_unit (
        .clk(clk),
        .rst(rst),
        .data(r_dot_result[x]),
        .ivalid(r_dot_ovalid[x]),
        .first(r_first),
        .last(r_last),
        .result(o_result[x]),
        .ovalid(o_valid)
    );
    end
endgenerate

// Controller Instantiation
ctrl # (.VEC_ADDRW(VEC_ADDRW), .MAT_ADDRW(MAT_ADDRW)) ctrl_unit (
    .clk(clk),
    .rst(rst),
    .start(i_start),
    .vec_start_addr(i_vec_start_addr),
    .vec_num_words(i_vec_num_words),
    .mat_start_addr(i_mat_start_addr),
    .mat_num_rows_per_olane(i_mat_num_rows_per_olane),
    .vec_raddr(r_vec_raddr),
    .mat_raddr(r_mat_raddr),
    .accum_first(r_first),
    .accum_last(r_last),
    .ovalid(r_ovalid),
    .busy(o_busy)
);

/******* Your code ends here ********/

endmodule