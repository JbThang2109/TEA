module tea_ctr (
    input wire clk,
    input wire rst,
    input wire start,
    input wire [127:0] key,
    input wire [63:0] nonce,
    input wire [63:0] data_in,
    output reg [63:0] data_out,
    output reg done
);
    reg [63:0] counter;
    reg [63:0] keystream;
    reg tea_start;
    wire [63:0] tea_ciphertext;
    wire tea_done;

    tea tea_inst (
        .clk(clk),
        .rst(rst),
        .start(tea_start),
        .plaintext({nonce, counter}),
        .key(key),
        .ciphertext(tea_ciphertext),
        .done(tea_done)
    );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            keystream <= 0;
            tea_start <= 0;
            done <= 0;
            data_out <= 0;
        end else if (start && !done) begin
            tea_start <= 1;
        end else if (tea_done) begin
            keystream <= tea_ciphertext;
            counter <= counter + 1;
            tea_start <= 0;
            data_out <= data_in ^ tea_ciphertext;
            done <= 1;
        end
    end
endmodule
