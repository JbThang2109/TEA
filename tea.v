module tea (
    input wire clk,
    input wire rst,
    input wire start,
    input wire [63:0] plaintext,
    input wire [127:0] key,
    output reg [63:0] ciphertext,
    output reg done
);
    reg [31:0] y, z;
    reg [31:0] sum;
    reg [4:0] round;
    wire [31:0] delta = 32'h9E3779B9;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y <= 0;
            z <= 0;
            sum <= 0;
            round <= 0;
            ciphertext <= 0;
            done <= 0;
        end else if (start && round == 0) begin
            y <= plaintext[63:32];
            z <= plaintext[31:0];
            sum <= 0;
            round <= 32;
            done <= 0;
        end else if (round > 0) begin
            sum <= sum + delta;
            y <= y + (((z << 4) + key[127:96]) ^ (z + sum) ^ ((z >> 5) + key[95:64]));
            z <= z + (((y << 4) + key[63:32]) ^ (y + sum) ^ ((y >> 5) + key[31:0]));
            round <= round - 1;
            if (round == 1) begin
                ciphertext <= {y, z};
                done <= 1;
            end
        end
    end
endmodule