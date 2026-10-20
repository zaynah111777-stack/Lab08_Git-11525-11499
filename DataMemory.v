`timescale 1ns / 1ps

// data memory= 512 locations x 32 bits
// write needs a clock we will do read is instant (no clock)
module DataMemory (
    input  wire        clk,
    input  wire        MemWrite,
    input  wire [8:0]  address,       // 0 to 511
    input  wire [31:0] write_data,
    output wire [31:0] read_data
);

    reg [31:0] mem [0:511];
    integer i;

    // fill with 0 at start so we dont read x
    initial begin
        for (i = 0; i < 512; i = i + 1)
            mem[i] = 32'd0;
    end

    // write only when MemWrite is 1
    always @(posedge clk) begin
        if (MemWrite)
            mem[address] <= write_data;
    end

    assign read_data = mem[address];

endmodule
