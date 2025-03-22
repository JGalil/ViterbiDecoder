// ? ask if we have to modify
module tbu
(
   input       clk,
   input       rst,
   input       enable,
   input       selection,
   input [7:0] d_in_0,
   input [7:0] d_in_1,
   output logic  d_o,
   output logic  wr_en);

   logic         d_o_reg;
   logic         wr_en_reg;
   
   logic   [2:0] pstate;
   logic   [2:0] nstate;

   logic         selection_buf;



always @(posedge clk or negedge rst) begin
      selection_buf  <= selection;
      wr_en          <= wr_en_reg;
      d_o            <= d_o_reg;
      if (!rst) begin
         pstate <= 3'b000;
      end else if (!enable) begin
         pstate <= 3'b000;
      end else begin
         pstate <= nstate;
      end
   end


always_comb begin
   nstate = pstate;
   wr_en_reg = 1'b0;
   d_o_reg = 1'b0;


   case(pstate)
   3'b000: 
      if(selection == 1'b0)begin
         wr_en_reg = 1'b0;
         case(d_in_0[0])
            1'b0: nstate = 3'b000;
            1'b1: nstate = 3'b001;
         endcase
      end
      else begin
         d_o_reg = d_in_1[0];
         wr_en_reg = 1'b1;
         case(d_in_1[0])
            1'b0: nstate = 3'b000;
            1'b1: nstate = 3'b001;
         endcase
      end

    3'b001: 
      if(selection == 1'b0) begin
         wr_en_reg = 1'b0;
         case(d_in_0[1])
            1'b0: nstate = 3'b011;
            1'b1: nstate = 3'b010;
         endcase
      end
      else begin
         d_o_reg = d_in_1[1];
         wr_en_reg = 1'b1;
         case(d_in_1[1])
            1'b0: nstate = 3'b011;
            1'b1: nstate = 3'b010;
         endcase
      end
   
   3'b010: 
      if(selection == 1'b0) begin
         wr_en_reg = 1'b0;
         case(d_in_0[2])
            1'b0: nstate = 3'b100;
            1'b1: nstate = 3'b101;
         endcase
      end
      else begin
         d_o_reg = d_in_1[2];
         wr_en_reg = 1'b1;
         case(d_in_1[2])
            1'b0: nstate = 3'b100;
            1'b1: nstate = 3'b101;
         endcase
      end


   3'b011: 
      if(selection == 1'b0) begin
         wr_en_reg = 1'b0;
         case(d_in_0[3])
            1'b0: nstate = 3'b111;
            1'b1: nstate = 3'b110;
         endcase
      end
      else begin
         d_o_reg = d_in_1[3];
         wr_en_reg = 1'b1;
         case(d_in_1[3])
            1'b0: nstate = 3'b111;
            1'b1: nstate = 3'b110;
         endcase
      end

   
   3'b100: 
      if(selection == 1'b0) begin
         wr_en_reg = 1'b0;
         case(d_in_0[4])
            1'b0: nstate = 3'b001;
            1'b1: nstate = 3'b000;
         endcase
      end
      else begin
         d_o_reg = d_in_1[4];
         wr_en_reg = 1'b1;
         case(d_in_1[4])
            1'b0: nstate = 3'b001;
            1'b1: nstate = 3'b000;
         endcase
      end
   
   
   3'b101: 
      if(selection == 1'b0) begin
         wr_en_reg = 1'b0;
         case(d_in_0[5])
            1'b0: nstate = 3'b010;
            1'b1: nstate = 3'b011;
         endcase
      end
      else begin
         d_o_reg = d_in_1[5];
         wr_en_reg = 1'b1;
         case(d_in_1[5])
            1'b0: nstate = 3'b010;
            1'b1: nstate = 3'b011;
         endcase
      end
   
   
   3'b110:
      if(selection == 1'b0) begin
         wr_en_reg = 1'b0;
         case(d_in_0[6])
            1'b0: nstate = 3'b101;
            1'b1: nstate = 3'b100;
         endcase
      end
      else begin
         d_o_reg = d_in_1[6];
         wr_en_reg = 1'b1;
         case(d_in_1[6])
            1'b0: nstate = 3'b101;
            1'b1: nstate = 3'b100;
         endcase
      end
   
   
   3'b111: 
      if(selection == 1'b0) begin
         wr_en_reg = 1'b0;
         case(d_in_0[7])
            1'b0: nstate = 3'b110;
            1'b1: nstate = 3'b111;
         endcase
      end
      else begin
         d_o_reg = d_in_1[7];
         wr_en_reg = 1'b1;
         case(d_in_1[7])
            1'b0: nstate = 3'b110;
            1'b1: nstate = 3'b111;
         endcase
      end
   

   endcase


end



endmodule


/*  combinational logic drives:
wr_en_reg, d_o_reg, nstate (next state)
from selection, d_in_1[pstate], d_in_0[pstate]
See assignment text for details
*/
