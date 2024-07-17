module tb_tea_ctr();
    // Khai báo tín hi?u
    reg clk;
    reg rst;
    reg start;
    reg [127:0] key;
    reg [63:0] nonce;
    reg [63:0] data_in;
    wire [63:0] data_out;
    wire done;

    // Kh?i t?o module TEA-CTR
    tea_ctr uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .key(key),
        .nonce(nonce),
        .data_in(data_in),
        .data_out(data_out),
        .done(done)
    );

    // T?o xung clock
    always #5 clk = ~clk;

    initial begin
        // Kh?i t?o tín hi?u
        clk = 0;
        rst = 1;
        start = 0;
        key = 128'h0123456789ABCDEF0123456789ABCDEF;
        nonce = 64'h1234567890ABCDEF;
        data_in = 64'h48656C6C6F20544541; // "Hello TEA" d??i d?ng hex

        // Th?c hi?n reset
        #10 rst = 0;

        // B?t ??u mã hóa
        #10 start = 1;
        #10 start = 0;

        // Ch? ??i hoàn thành
        wait(done);

        // In k?t qu? mã hóa
        $display("Encrypted Data: %h", data_out);

        // Thi?t l?p l?i d? li?u ?? gi?i mã
        data_in = data_out;
        rst = 1;
        #10 rst = 0;

        // B?t ??u gi?i mã
        #10 start = 1;
        #10 start = 0;

        // Ch? ??i hoàn thành
        wait(done);

        // In k?t qu? gi?i mã
        $display("Decrypted Data: %h", data_out);

        // K?t thúc mô ph?ng
        $finish;
    end
endmodule
