/***************************************************/
/* ECE 327: Digital Hardware Systems - Spring 2025 */
/* Lab 2 - Part 2                                  */
/* Traffic Light Controller Testbench              */
/***************************************************/

`timescale 1ns/1ps

// Define the name of this testbench module. Since testbenches typically generate inputs and
// monitor outputs of the circuit being tested, they usually do not have any input/output ports.
module traffic_tb ();

// Assumed no. of clock cycles per second to be passed to the traffic light controller module.
// It is set to 16 instead of 125000000 in the testbench to run shorted simulation. Refer to
// the Lab 2 handout for a more detailed explanation
localparam CYCLES_PER_SEC = 16; 
localparam CLK_PERIOD = 2; // Clock period in nanoseconds

// Design specific parameters that could help you when writing the testbench. A traffic cycle
// is 10 seconds and a pedestrian crossing slot is 4 seconds. You can choose not to use these
// parameters if you want, but they should make your testbench cleaner.
localparam bit [63:0] CYCLES_PER_TRAFFIC_CYCLE = 10 * CYCLES_PER_SEC;
localparam bit [63:0] CYCLES_PER_PEDESTRIAN_CROSSING = 4 * CYCLES_PER_SEC;

// Declare logic signals for the circuit's inputs/outputs
logic clk;
logic i_maintenance;
logic [3:0] i_ped_buttons;
logic [2:0] o_light_ns;
logic [2:0] o_light_ew;
logic o_light_ped;

// Signal to identify if simulation passed (1'b0) or failed (1'b1). Your testbench should test
// the design and set this signal accordingly.
logic sim_failed;

// Instantiate the design under test (dut), set the desired values of its parameters, and connect 
// its input/output ports to the declared signals.
traffic # (
    .CYCLES_PER_SEC(CYCLES_PER_SEC)
) dut (
    .clk(clk),
    .i_maintenance(i_maintenance),
    .i_ped_buttons(i_ped_buttons),
    .o_light_ns(o_light_ns),
    .o_light_ew(o_light_ew),
    .o_light_ped(o_light_ped)
);

// This initial block generates a clock signal
initial begin
    clk = 1'b0;
    forever #(CLK_PERIOD/2) clk = ~clk;
end

/******* Your code starts here *******/
logic test;
/******* Your code ends here ********/

initial begin
    // Reset all testbench signals
    sim_failed = 1'b0;
    i_maintenance = 1'b1;
    i_ped_buttons = 4'b0000;
    #(5*CLK_PERIOD);
    
    /******* Your code starts here *******/
    #(CLK_PERIOD/2);
    i_maintenance = 1'b0;
    
    test = 1'b0;

    // Test NS Green
    test = ~test;
    for (int cycle_count = 0; cycle_count < (CYCLES_PER_SEC*3); cycle_count = cycle_count + 1) begin
        if (o_light_ns != 3'b010 || o_light_ew != 3'b100 || o_light_ped != 0) begin
            $display("FAILED at cycle %d: NS Green!", cycle_count);
            sim_failed = 1'b1;
        end
        #(CLK_PERIOD);
    end

    // Test NS Yellow
    test = ~test;
    for (int cycle_count = 0; cycle_count < (CYCLES_PER_SEC*2); cycle_count = cycle_count + 1) begin
        if (o_light_ns != 3'b110 || o_light_ew != 3'b100 || o_light_ped != 0) begin
            $display("FAILED at cycle %d: NS Yellow!", cycle_count);
            sim_failed = 1'b1;
        end
        #(CLK_PERIOD);
    end
    
    // Test Maintenance
    test = ~test;
    i_maintenance = 1'b1;
    #(CLK_PERIOD);
    for (int cycle_count = 0; cycle_count < (CYCLES_PER_SEC); cycle_count = cycle_count + 1) begin
        if (o_light_ns != 3'b010 || o_light_ew != 3'b100 || o_light_ped != 0) begin
            $display("FAILED at cycle %d: NS Green!", cycle_count);
            sim_failed = 1'b1;
        end
        #(CLK_PERIOD);
    end
    i_maintenance = 1'b0;
    
    // Test NS Green
    test = ~test;
    for (int cycle_count = 0; cycle_count < (CYCLES_PER_SEC*3); cycle_count = cycle_count + 1) begin
        if (o_light_ns != 3'b010 || o_light_ew != 3'b100 || o_light_ped != 0) begin
            $display("FAILED at cycle %d: NS Green!", cycle_count);
            sim_failed = 1'b1;
        end
        #(CLK_PERIOD);
    end
    
    // Test NS Yellow
    test = ~test;
    for (int cycle_count = 0; cycle_count < (CYCLES_PER_SEC*2); cycle_count = cycle_count + 1) begin
        if (o_light_ns != 3'b110 || o_light_ew != 3'b100 || o_light_ped != 0) begin
            $display("FAILED at cycle %d: NS Yellow!", cycle_count);
            sim_failed = 1'b1;
        end
        #(CLK_PERIOD);
    end
    
    // Test Pedestrian Push Button
    i_ped_buttons = 1;
    
    // Test EW Green
    test = ~test;
    for (int cycle_count = 0; cycle_count < (CYCLES_PER_SEC*3); cycle_count = cycle_count + 1) begin
        if (o_light_ns != 3'b100 || o_light_ew != 3'b010 || o_light_ped != 0) begin
            $display("FAILED at cycle %d: EW Green!", cycle_count);
            sim_failed = 1'b1;
        end
        #(CLK_PERIOD);
    end
    
    i_ped_buttons = 0;
    
    // Test EW Yellow
    test = ~test;
    for (int cycle_count = 0; cycle_count < (CYCLES_PER_SEC*2); cycle_count = cycle_count + 1) begin
        if (o_light_ns != 3'b100 || o_light_ew != 3'b110 || o_light_ped != 0) begin
            $display("FAILED at cycle %d: EW Yellow!", cycle_count);
            sim_failed = 1'b1;
        end
        #(CLK_PERIOD);
    end
    
    // Test Pedestrian LED ON
    test = ~test;
    for (int cycle_count = 0; cycle_count < (CYCLES_PER_SEC*2); cycle_count = cycle_count + 1) begin
        i_ped_buttons = 1;
        if (o_light_ns != 3'b100 || o_light_ew != 3'b100 || o_light_ped != 1) begin
            $display("FAILED at cycle %d: PED LIGHT!!", cycle_count);
            sim_failed = 1'b1;
        end
        #(CLK_PERIOD);
    end
    i_ped_buttons = 0;
    
    // Test Pedestrian LED Blink
    test = ~test;
    for (int blink_count = 0; blink_count < 4; blink_count = blink_count + 1) begin
        for (int cycle_count = 0; cycle_count < (CYCLES_PER_SEC/4); cycle_count = cycle_count + 1) begin
            if (o_light_ns != 3'b100 || o_light_ew != 3'b100 || o_light_ped != 0) begin
                $display("FAILED at cycle %d: PED LIGHT!!", cycle_count);
                sim_failed = 1'b1;
            end
            #(CLK_PERIOD);
        end
        for (int cycle_count = 0; cycle_count < (CYCLES_PER_SEC/4); cycle_count = cycle_count + 1) begin
            if (o_light_ns != 3'b100 || o_light_ew != 3'b100 || o_light_ped != 1) begin
                $display("FAILED at cycle %d: PED LIGHT!!", cycle_count);
                sim_failed = 1'b1;
            end
            #(CLK_PERIOD);
        end
    end
    
    // Test NS Green
    test = ~test;
    for (int cycle_count = 0; cycle_count < (CYCLES_PER_SEC*3); cycle_count = cycle_count + 1) begin
        if (o_light_ns != 3'b010 || o_light_ew != 3'b100 || o_light_ped != 0) begin
            $display("FAILED at cycle %d: NS Green!", cycle_count);
            sim_failed = 1'b1;
        end
        #(CLK_PERIOD);
    end
    
    // Test NS Yellow
    test = ~test;
    for (int cycle_count = 0; cycle_count < (CYCLES_PER_SEC*2); cycle_count = cycle_count + 1) begin
        if (o_light_ns != 3'b110 || o_light_ew != 3'b100 || o_light_ped != 0) begin
            $display("FAILED at cycle %d: NS Yellow!", cycle_count);
            sim_failed = 1'b1;
        end
        #(CLK_PERIOD);
    end
 
    // Test EW Green
    test = ~test;
    for (int cycle_count = 0; cycle_count < (CYCLES_PER_SEC*3); cycle_count = cycle_count + 1) begin
        if (o_light_ns != 3'b100 || o_light_ew != 3'b010 || o_light_ped != 0) begin
            $display("FAILED at cycle %d: EW Green!", cycle_count);
            sim_failed = 1'b1;
        end
        #(CLK_PERIOD);
    end

    // Test EW Yellow
    test = ~test;
    for (int cycle_count = 0; cycle_count < (CYCLES_PER_SEC*2); cycle_count = cycle_count + 1) begin
        if (o_light_ns != 3'b100 || o_light_ew != 3'b110 || o_light_ped != 0) begin
            $display("FAILED at cycle %d: EW Yellow!", cycle_count);
            sim_failed = 1'b1;
        end
        #(CLK_PERIOD);
    end
    
     // Test NS Green
    test = ~test;
    for (int cycle_count = 0; cycle_count < (CYCLES_PER_SEC*3); cycle_count = cycle_count + 1) begin
        if (o_light_ns != 3'b010 || o_light_ew != 3'b100 || o_light_ped != 0) begin
            $display("FAILED at cycle %d: NS Green!", cycle_count);
            sim_failed = 1'b1;
        end
        #(CLK_PERIOD);
    end
    
    // Test NS Yellow
    test = ~test;
    for (int cycle_count = 0; cycle_count < (CYCLES_PER_SEC*2); cycle_count = cycle_count + 1) begin
        if (o_light_ns != 3'b110 || o_light_ew != 3'b100 || o_light_ped != 0) begin
            $display("FAILED at cycle %d: NS Yellow!", cycle_count);
            sim_failed = 1'b1;
        end
        #(CLK_PERIOD);
    end
 
    // Test EW Green
    test = ~test;
    for (int cycle_count = 0; cycle_count < (CYCLES_PER_SEC*3); cycle_count = cycle_count + 1) begin
        if (o_light_ns != 3'b100 || o_light_ew != 3'b010 || o_light_ped != 0) begin
            $display("FAILED at cycle %d: EW Green!", cycle_count);
            sim_failed = 1'b1;
        end
        #(CLK_PERIOD);
    end

    // Test EW Yellow
    test = ~test;
    for (int cycle_count = 0; cycle_count < (CYCLES_PER_SEC*2); cycle_count = cycle_count + 1) begin
        if (o_light_ns != 3'b100 || o_light_ew != 3'b110 || o_light_ped != 0) begin
            $display("FAILED at cycle %d: EW Yellow!", cycle_count);
            sim_failed = 1'b1;
        end
        #(CLK_PERIOD);
    end
    
    i_maintenance = 1;
    i_ped_buttons = 1;
    #(CLK_PERIOD*CYCLES_PER_SEC);
    i_ped_buttons = 0;
    i_maintenance = 0;
    
         // Test NS Green
    test = ~test;
    for (int cycle_count = 0; cycle_count < (CYCLES_PER_SEC*3); cycle_count = cycle_count + 1) begin
        if (o_light_ns != 3'b010 || o_light_ew != 3'b100 || o_light_ped != 0) begin
            $display("FAILED at cycle %d: NS Green!", cycle_count);
            sim_failed = 1'b1;
        end
        #(CLK_PERIOD);
    end
    
    // Test NS Yellow
    test = ~test;
    for (int cycle_count = 0; cycle_count < (CYCLES_PER_SEC*2); cycle_count = cycle_count + 1) begin
        if (o_light_ns != 3'b110 || o_light_ew != 3'b100 || o_light_ped != 0) begin
            $display("FAILED at cycle %d: NS Yellow!", cycle_count);
            sim_failed = 1'b1;
        end
        #(CLK_PERIOD);
    end
    
        // Test EW Green
    test = ~test;
    for (int cycle_count = 0; cycle_count < (CYCLES_PER_SEC*3); cycle_count = cycle_count + 1) begin
        if (o_light_ns != 3'b100 || o_light_ew != 3'b010 || o_light_ped != 0) begin
            $display("FAILED at cycle %d: EW Green!", cycle_count);
            sim_failed = 1'b1;
        end
        #(CLK_PERIOD);
    end

    // Test EW Yellow
    test = ~test;
    for (int cycle_count = 0; cycle_count < (CYCLES_PER_SEC*2); cycle_count = cycle_count + 1) begin
        if (o_light_ns != 3'b100 || o_light_ew != 3'b110 || o_light_ped != 0) begin
            $display("FAILED at cycle %d: EW Yellow!", cycle_count);
            sim_failed = 1'b1;
        end
        #(CLK_PERIOD);
    end
    
    // Test NS Green
    test = ~test;
    for (int cycle_count = 0; cycle_count < (CYCLES_PER_SEC*3); cycle_count = cycle_count + 1) begin
        if (o_light_ns != 3'b010 || o_light_ew != 3'b100 || o_light_ped != 0) begin
            $display("FAILED at cycle %d: NS Green!", cycle_count);
            sim_failed = 1'b1;
        end
        #(CLK_PERIOD);
    end
    
    // Test NS Yellow
    test = ~test;
    for (int cycle_count = 0; cycle_count < (CYCLES_PER_SEC*2); cycle_count = cycle_count + 1) begin
        if (o_light_ns != 3'b110 || o_light_ew != 3'b100 || o_light_ped != 0) begin
            $display("FAILED at cycle %d: NS Yellow!", cycle_count);
            sim_failed = 1'b1;
        end
        #(CLK_PERIOD);
    end
    
    
    /******* Your code ends here ********/
    
    if (sim_failed) begin
        $display("TEST FAILED!");
    end else begin
        $display("TEST PASSED!");
    end 
    $stop;
end


endmodule