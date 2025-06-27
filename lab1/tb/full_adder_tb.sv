/***************************************************/
/* ECE 327: Digital Hardware Systems - Spring 2025 */
/* Lab 1 - Part 1                                  */
/* Testbench for full adder module                 */
/***************************************************/

`timescale 1ns/1ps

// Define the name of this testbench module. Since testbenches typically generate inputs and
// monitor outputs of the circuit being tested, they usually do not have any input/output ports.
module full_adder_tb ();

// Declare logic signals for the circuit's inputs/outputs
logic a_sig, b_sig, cin_sig;
logic s_sig, cout_sig;

// Instantiate the design under test (dut) and connect its input/output ports to the declared 
// signals.
full_adder dut (
    .a(a_sig),
    .b(b_sig),
    .cin(cin_sig),
    .s(s_sig),
    .cout(cout_sig)
);

// Since this is a small circuit with only three 1-bit inputs, it is possible to exhaustively
// test all input combinations (8 test cases in total). For each test case, we will set the 
// inputs (a_sig, b_sig, cin_sig), wait 2 ns, and display outputs (s_sig, cout_sig) along with
// their manually calculated expected values. We can visually check if the produced outputs
// match the expected values or not to verify correctness -- not a good idea for larger and more
// complex designs as you will see in parts 2 and 3 of this lab.
initial begin
    // Set time display format to be in 10^-9 sec, with 2 decimal places, and add " ns" suffix
    $timeformat(-9, 2, " ns");
    
    // Test case 1
    a_sig = 1'b0; b_sig = 1'b0; cin_sig = 1'b0; #2;
    $display("[%0t] Got: Sum=%b, Cout=%b -- Expecting: Sum=0, Cout=0", $time, s_sig, cout_sig);
    // Test case 2
    a_sig = 1'b0; b_sig = 1'b0; cin_sig = 1'b1; #2;
    $display("[%0t] Got: Sum=%b, Cout=%b -- Expecting: Sum=1, Cout=0", $time, s_sig, cout_sig);
    // Test case 3
    a_sig = 1'b0; b_sig = 1'b1; cin_sig = 1'b0; #2;
    $display("[%0t] Got: Sum=%b, Cout=%b -- Expecting: Sum=1, Cout=0", $time, s_sig, cout_sig);
    // Test case 4
    a_sig = 1'b0; b_sig = 1'b1; cin_sig = 1'b1; #2;
    $display("[%0t] Got: Sum=%b, Cout=%b -- Expecting: Sum=0, Cout=1", $time, s_sig, cout_sig);
    // Test case 5
    a_sig = 1'b1; b_sig = 1'b0; cin_sig = 1'b0; #2;
    $display("[%0t] Got: Sum=%b, Cout=%b -- Expecting: Sum=1, Cout=0", $time, s_sig, cout_sig);
    // Test case 6
    a_sig = 1'b1; b_sig = 1'b0; cin_sig = 1'b1; #2;
    $display("[%0t] Got: Sum=%b, Cout=%b -- Expecting: Sum=0, Cout=1", $time, s_sig, cout_sig);
    // Test case 7
    a_sig = 1'b1; b_sig = 1'b1; cin_sig = 1'b0; #2;
    $display("[%0t] Got: Sum=%b, Cout=%b -- Expecting: Sum=0, Cout=1", $time, s_sig, cout_sig);
    // Test case 8
    a_sig = 1'b1; b_sig = 1'b1; cin_sig = 1'b1; #2;
    $display("[%0t] Got: Sum=%b, Cout=%b -- Expecting: Sum=1, Cout=1", $time, s_sig, cout_sig);
    // Stop the simulation
    $display("Test Complete!");
    $stop;
end

endmodule