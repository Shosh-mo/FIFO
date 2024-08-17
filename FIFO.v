module FIFO (din_a , wen_a , ren_b , clk_a , clk_b , rst , dout_b , full , empty);
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 512;

input [FIFO_WIDTH-1 :0] din_a;
input wen_a , ren_b , clk_a , clk_b , rst;
output reg [FIFO_WIDTH-1 :0] dout_b;
output full , empty;

reg [$clog2(FIFO_DEPTH)-1:0] wr_ptr , rd_ptr;
reg [FIFO_WIDTH:0] mem [FIFO_DEPTH-1:0];

always @(posedge clk_a) begin
    if(rst) begin
        wr_ptr <= 0;
    end
    else begin
        if(full == 0 && wen_a == 1) begin
            mem[wr_ptr] <= din_a;
            wr_ptr <= wr_ptr + 1;
        end
    end
end

always @(posedge clk_b) begin
    if(rst) begin
        rd_ptr <= 0;
        dout_b <= 0;
    end
    else begin
        if(empty == 0 && ren_b == 1) begin
            dout_b <= mem[rd_ptr];
            rd_ptr <= rd_ptr + 1;
        end
    end
end
assign full = (((wr_ptr == 511) && (rd_ptr==0))&&(wen_a == 1)) || (((wr_ptr+1) == rd_ptr)&&(wen_a == 1));
assign empty = (wr_ptr == rd_ptr);
endmodule
