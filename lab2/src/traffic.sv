/***************************************************/
/* ECE 327: Digital Hardware Systems - Spring 2025 */
/* Lab 2 - Part 1                                  */
/* Traffic Light Controller Module                 */
/***************************************************/

module traffic # (
    parameter CYCLES_PER_SEC = 125000000 // No. of clock cycles per 1 second of wall clock time
)(
    input  clk,                 // Input clock signal
    input  i_maintenance,       // Maintenance signal
    input  [3:0] i_ped_buttons, // Four input pedestrian crossing push buttons
    output [2:0] o_light_ns,    // Traffic light of North-South street {red, green, blue}
    output [2:0] o_light_ew,    // Traffic light of East-West street {red, green, blue}
    output o_light_ped          // Pedestrian all-way crossing light
);

// Define local parameters for the RGB outputs corresponding to red, yellow, and green lights
// This allows you to cleanely set traffic light outputs (e.g., r_light_ns <= GREEN_LIGHT)
localparam GREEN_LIGHT  = 3'b010,
           YELLOW_LIGHT = 3'b110,
           RED_LIGHT    = 3'b100;

// Output registers assigned to the output ports of the module. Your FSM logic will set the
// values of these registers.
logic [2:0] r_light_ns, r_light_ew;
logic r_light_ped;

/******* Your code starts here *******/
localparam QUARTER_SEC_CYCLES = CYCLES_PER_SEC/4;
enum {NS_G, NS_Y, EW_G, EW_Y, PED_CROSS, PED_BLINK} state, next_state;
logic [3:0] time_count;
logic [27:0] cycle_count;
logic ped_flag;
logic ped_blink_toggle;

always_ff @(posedge clk) begin
    // Pedestrian request flag
    if (state == PED_CROSS || state == PED_BLINK) ped_flag <= 0;
    else if (i_ped_buttons != 0) ped_flag <= 1;
   
    if(i_maintenance) begin
        time_count <= 0;
        cycle_count <= 0;
        state <= NS_G;
        ped_flag <= 0;
        ped_blink_toggle <= 0;
    end else begin
        if (cycle_count == CYCLES_PER_SEC - 1) begin
            cycle_count <= 0;
            if (next_state == NS_G && state != next_state) begin
                time_count <= 0;
            end else begin
                time_count <= time_count + 1;
            end
            state <= next_state;
        end else begin
            cycle_count <= cycle_count + 1;
        end

        if (state == PED_BLINK) begin
            if (cycle_count == QUARTER_SEC_CYCLES - 1 || cycle_count == (2*QUARTER_SEC_CYCLES) - 1 || cycle_count == (3*QUARTER_SEC_CYCLES) - 1 || cycle_count == (4*QUARTER_SEC_CYCLES) - 1) begin
                ped_blink_toggle <= ~ped_blink_toggle;
            end
        end else begin
            ped_blink_toggle <= 0;
        end
    end
end

// State Decoder
always_comb begin: state_decoder
    case (state)
        NS_G: next_state = (time_count==2)? NS_Y : NS_G;
        NS_Y: next_state = (time_count==4)? EW_G : NS_Y;
        EW_G: next_state = (time_count==7)? EW_Y : EW_G;
        EW_Y: next_state = (time_count==9)? (ped_flag)? PED_CROSS : NS_G : EW_Y;
        PED_CROSS: next_state = (time_count==11)? PED_BLINK : PED_CROSS;
        PED_BLINK: next_state = (time_count==13)? NS_G : PED_BLINK;
        default: next_state = NS_G;
    endcase
end

// Output Decoder
always_comb begin: out_decoder
    r_light_ped = 0;
    case (state)
        NS_G: begin
            r_light_ns = GREEN_LIGHT;
            r_light_ew = RED_LIGHT;
            r_light_ped = 0;
        end NS_Y: begin
            r_light_ns = YELLOW_LIGHT;
            r_light_ew = RED_LIGHT;
            r_light_ped = 0;
        end EW_G: begin
            r_light_ns = RED_LIGHT;
            r_light_ew = GREEN_LIGHT;
            r_light_ped = 0;
        end EW_Y: begin
            r_light_ns = RED_LIGHT;
            r_light_ew = YELLOW_LIGHT;
            r_light_ped = 0;
        end PED_CROSS: begin
            r_light_ns = RED_LIGHT;
            r_light_ew = RED_LIGHT;
            r_light_ped = 1;
        end PED_BLINK: begin
            r_light_ns = RED_LIGHT;
            r_light_ew = RED_LIGHT;
            r_light_ped = ped_blink_toggle;
        end default: begin
            r_light_ns = GREEN_LIGHT;
            r_light_ew = RED_LIGHT;
            r_light_ped = 0;
        end
    endcase
end
/******* Your code ends here ********/

// Assignt the output registers set by your FSM logic to the input/output ports of the module.
assign o_light_ns = r_light_ns;
assign o_light_ew = r_light_ew;
assign o_light_ped = r_light_ped;

endmodule