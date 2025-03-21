module mem_disp (
    input clk, wr,
    input [9:0] addr,
    input d_i,
    output logic d_o
);

logic mem [1023:0];

always @ (posedge clk) begin
    if(wr)
    mem[addr] <= d_i;
    d_o <= mem[addr];
end
endmodule: mem_disp