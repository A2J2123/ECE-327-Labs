/***************************************************/
/* ECE 327: Digital Hardware Systems - Spring 2025 */
/* Lab 4                                           */
/* MVM Control FSM                                 */
/***************************************************/

module ctrl # (
    parameter VEC_ADDRW = 8,
    parameter MAT_ADDRW = 9,
    parameter VEC_SIZEW = VEC_ADDRW + 1,
    parameter MAT_SIZEW = MAT_ADDRW + 1
    
)(
    input  clk,
    input  rst,
    input  start,
    input  [VEC_ADDRW-1:0] vec_start_addr,
    input  [VEC_SIZEW-1:0] vec_num_words,
    input  [MAT_ADDRW-1:0] mat_start_addr,
    input  [MAT_SIZEW-1:0] mat_num_rows_per_olane,
    output [VEC_ADDRW-1:0] vec_raddr,
    output [MAT_ADDRW-1:0] mat_raddr,
    output accum_first,
    output accum_last,
    output ovalid,
    output busy
);

/******* Your code starts here *******/
// States
enum {IDLE, COMPUTE} state, next_state;

// Input Registers
logic [VEC_ADDRW-1:0] r_vec_start_addr;
logic [VEC_SIZEW-1:0] r_vec_num_words;
logic [MAT_ADDRW-1:0] r_mat_start_addr;
logic [MAT_SIZEW-1:0] r_mat_num_rows_per_olane;
// Temporary Registers for Inputs
logic [VEC_ADDRW-1:0] t_vec_start_addr;
logic [VEC_SIZEW-1:0] t_vec_num_words;
logic [MAT_ADDRW-1:0] t_mat_start_addr;
logic [MAT_SIZEW-1:0] t_mat_num_rows_per_olane;

// Output Registers
logic [VEC_ADDRW-1:0] r_vec_raddr;
logic [MAT_ADDRW-1:0] r_mat_raddr;
logic r_accum_first [6:0];
logic r_accum_last [6:0];
logic r_ovalid [1:0];
logic r_busy;
// Temporary Registers for Outputs
logic [VEC_ADDRW-1:0] t_vec_raddr;
logic [MAT_ADDRW-1:0] t_mat_raddr;
logic t_accum_first;
logic t_accum_last;
logic t_ovalid;
logic t_busy;

// Word Count Registers
logic [7:0] r_word_count;
logic [7:0] t_word_count;

always_ff @(posedge clk) begin
    if (rst) begin
        r_vec_start_addr <= 0;
        r_vec_num_words <= 0;
        r_mat_start_addr <= 0;
        r_mat_num_rows_per_olane <= 0;
        r_vec_raddr <= 0;
        r_mat_raddr <= 0;
        r_accum_first [0] <= 0; r_accum_first [1] <= 0; r_accum_first [2] <= 0; r_accum_first [3] <= 0; r_accum_first [4] <= 0; r_accum_first [5] <= 0; r_accum_first [6] <= 0;
        r_accum_last [0] <= 0; r_accum_last [1] <= 0; r_accum_last [2] <= 0; r_accum_last [3] <= 0; r_accum_last [4] <= 0; r_accum_last [5] <= 0; r_accum_last [6] <= 0;
        r_ovalid[0] <= 0; r_ovalid[1] <= 0;
        r_busy <= 0;
        r_word_count <= 0;
    end else begin
        r_vec_start_addr <= t_vec_start_addr;
        r_vec_num_words <= t_vec_num_words;
        r_mat_start_addr <= t_mat_start_addr;
        r_mat_num_rows_per_olane <= t_mat_num_rows_per_olane;
        r_vec_raddr <= t_vec_raddr;
        r_mat_raddr <= t_mat_raddr;
        r_accum_first [0] <= t_accum_first; r_accum_first [1] <= r_accum_first [0]; r_accum_first [2] <= r_accum_first [1]; r_accum_first [3] <= r_accum_first [2]; r_accum_first [4] <= r_accum_first [3]; r_accum_first [5] <= r_accum_first [4]; r_accum_first [6] <= r_accum_first [5];
        r_accum_last [0] <= t_accum_last; r_accum_last [1] <= r_accum_last [0]; r_accum_last [2] <= r_accum_last [1]; r_accum_last [3] <= r_accum_last [2]; r_accum_last [4] <= r_accum_last [3]; r_accum_last [5] <= r_accum_last [4]; r_accum_last [6] <= r_accum_last [5];
        r_ovalid[0] <= t_ovalid; r_ovalid[1] <= r_ovalid[0];
        r_busy <= t_busy;
        r_word_count <= t_word_count;
        state <= next_state;
    end
end

// State Decoder
always_comb begin: state_decoder
    case (state)
        COMPUTE : next_state = (r_busy)? COMPUTE : IDLE;
        default: next_state = (start)? COMPUTE : IDLE;
    endcase
end

// Output Decoder
always_comb begin: out_decoder
    case(state)
        COMPUTE: begin
            t_vec_start_addr <= r_vec_start_addr;
            t_vec_num_words <= r_vec_num_words;
            t_mat_start_addr <= r_mat_start_addr;
            t_mat_num_rows_per_olane <= r_mat_num_rows_per_olane;
            if ((r_vec_raddr + 1) == (r_vec_start_addr + vec_num_words)) begin
                t_vec_raddr <= vec_start_addr;
                t_accum_first <= 1;
            end else begin
                t_vec_raddr <= r_vec_raddr + 1;
                t_accum_first <= 0;
            end 
            t_mat_raddr <= r_mat_raddr + 1;
            if ((r_vec_raddr + 2) == (r_vec_start_addr + vec_num_words)) begin
                t_accum_last <= 1;
            end else begin
                t_accum_last <= 0;
            end
            t_ovalid <= r_busy;
            if (r_word_count == (r_vec_num_words * r_mat_num_rows_per_olane)) begin
                t_busy <= 0;
            end else begin
                t_busy <= 1;
            end
            t_word_count <= r_word_count + 1;
        end default: begin
            if (start) begin
                t_vec_start_addr <= r_vec_start_addr;
                t_vec_num_words <= r_vec_num_words;
                t_mat_start_addr <= r_mat_start_addr;
                t_mat_num_rows_per_olane <= r_mat_num_rows_per_olane;
                t_vec_raddr <= r_vec_raddr;
                t_mat_raddr <= r_mat_raddr;
                t_accum_first <= 1;
                t_accum_last <= 0;
                t_ovalid <= 1;
                t_busy <= 1;
                t_word_count <= 1;
            end else begin
                t_vec_start_addr <= vec_start_addr;
                t_vec_num_words <= vec_num_words;
                t_mat_start_addr <= mat_start_addr;
                t_mat_num_rows_per_olane <= mat_num_rows_per_olane;
                t_vec_raddr <= 0;
                t_mat_raddr <= 0;
                t_accum_first <= 0;
                t_accum_last <= 0;
                t_ovalid <= 0;
                t_busy <= 0;
                t_word_count <= 0;
            end
        end
    endcase
end

assign vec_raddr = r_vec_raddr;
assign mat_raddr = r_mat_raddr;
assign accum_first = r_accum_first[6];
assign accum_last = r_accum_last[6];
assign ovalid = r_ovalid[1];
assign busy = r_busy;
/******* Your code ends here ********/

endmodule