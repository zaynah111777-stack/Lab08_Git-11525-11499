`timescale 1ns / 1ps

// this is what the cpu talks to
// one address bus, the decoder picks who answers
module addressDecoderTop(
    input  wire        clk,
    input  wire        rst,
    input  wire [31:0] address,
    input  wire        readEnable,
    input  wire        writeEnable,
    input  wire [31:0] writeData,
    input  wire [15:0] switches,
    output wire [31:0] readData,
    output wire [15:0] leds
);

    wire DataMemWrite, DataMemRead, LEDWrite, SwitchReadEnable;
    wire [31:0] memData, switchData, ledReadData;

    AddressDecoder dec (
        .address(address[9:0]),
        .readEnable(readEnable), .writeEnable(writeEnable),
        .DataMemWrite(DataMemWrite), .DataMemRead(DataMemRead),
        .LEDWrite(LEDWrite), .SwitchReadEnable(SwitchReadEnable)
    );

    DataMemory dmem (
        .clk(clk), .MemWrite(DataMemWrite),
        .address(address[8:0]), .write_data(writeData),
        .read_data(memData)
    );

    // lab 5 modules. names are backwards from what they do
    // leds = reads the switches, switches = drives the LEDs
    leds switch_reader (
        .clk(clk), .rst(rst), .btns(16'd0),
        .writeData(32'd0), .writeEnable(1'b0),
        .readEnable(SwitchReadEnable), .memAddress({22'd0, address[7:0]}),
        .switches(switches), .readData(switchData)
    );

    switches led_writer (
        .clk(clk), .rst(rst),
        .writeData(writeData), .writeEnable(LEDWrite),
        .readEnable(1'b0), .memAddress({22'd0, address[7:0]}),
        .readData(ledReadData), .leds(leds)
    );

    // only the picked device puts data on readData, else 0
    assign readData = SwitchReadEnable ? switchData :
                      DataMemRead      ? memData    : 32'd0;

endmodule
