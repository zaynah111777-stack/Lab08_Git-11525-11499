`timescale 1ns / 1ps

// memory mapp
//   0   - 511  = data memory
//   512 - 767  = LEDs
//   768 - 1023 = switches
// only the lower 10 bits of the address matter
module AddressDecoder (
    input  wire [9:0] address,
    input  wire       readEnable,
    input  wire       writeEnable,
    output wire       DataMemWrite,
    output wire       DataMemRead,
    output wire       LEDWrite,
    output wire       SwitchReadEnable
);

    // which device is picked
    wire DataMemSelect = ~address[9];                // 0 - 511
    wire LEDSelect     =  address[9] & ~address[8];  // 512 - 767
    wire SwitchSelect  =  address[9] &  address[8];  // 768 - 1023

    // memory can read + write, LEDs write only, switches read only
    assign DataMemWrite     = DataMemSelect & writeEnable;
    assign DataMemRead      = DataMemSelect & readEnable;
    assign LEDWrite         = LEDSelect     & writeEnable;
    assign SwitchReadEnable = SwitchSelect  & readEnable;

endmodule
