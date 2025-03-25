// contains convolutional encoder,
//  (possibly corrupting) channel,
//  and Viterbi decoder
// parameter N sets the channel bit error rate
// this time, bit[0] every 16 clocks
module viterbi_tx_rx2b8 #(parameter N=5) (
   input    clk,
   input    rst,
   input    encoder_i,
   input    enable_encoder_i,
   output   decoder_o);

   wire  [1:0] encoder_o;  // connects encoder to decoder

   int           error_counter,	err_trig,
                 bad_bit_ct,
                 word_ct;
   logic   [1:0] encoder_o_reg0,
                 encoder_o_reg;
   logic         encoder_i_reg;
   logic         enable_decoder_in;
   logic         enable_encoder_i_reg;
   wire          valid_encoder_o;
   logic   [1:0] err_inj;

   always @ (posedge clk, negedge rst) 
      if(!rst) begin  
	  $display("viterbi_tx_rx2.sv");
         error_counter        <= 'd0;
         encoder_o_reg        <= 'b0;		 
		 encoder_o_reg0       <= 'b0;
         enable_decoder_in    <= 'b0;
		 enable_encoder_i_reg <= 'b0;
		 word_ct              <= 'b0;
      end
      else begin 
         enable_encoder_i_reg <= enable_encoder_i;  
         enable_decoder_in    <= valid_encoder_o; 
// bit error injection in encoder_o_reg        					           					           
         encoder_i_reg     <= encoder_i;
         encoder_o_reg0    <= encoder_o;
// word_ct[N-1:0] generates strings of 2**N consecutive errors
         word_ct              <= word_ct + 1;	err_trig = 16'hABCD;		
      if (word_ct % 32 == 0 && ($random % 2)) begin  // 50% chance to trigger
         int burst_start = $random % 31;  // Random start position within 32-sample window
         for (int i = 0; i < 2; i++) begin
            if (word_ct % 32 == (burst_start + i) % 32) begin
                  encoder_o_reg <= ~encoder_o;  // Invert both bits
                  if (i == 0) error_counter <= error_counter + 1;
            end
         end
      end else begin
         encoder_o_reg <= encoder_o;
      end
        if(word_ct<256) begin
          bad_bit_ct  <= bad_bit_ct + (encoder_o_reg0[1]^encoder_o_reg[1])
		                      + (encoder_o_reg0[0]^encoder_o_reg[0]);
		  $display("error_counter,err_inj = %h %b %d %d",
		         error_counter,err_inj,bad_bit_ct,word_ct);
        end
      end   

																			   
// insert your convolutional encoder here
// change port names and module name as necessary/desired
   encoder2 encoder1	     (
      .clk,
      .rst,
      .enable_i(enable_encoder_i), //_reg),
      .d_in    (encoder_i),        //_reg),
      .valid_o (valid_encoder_o),
      .d_out   (encoder_o)   );

// insert your term project code here 
   decoder decoder1	     (
      .clk,
      .rst,
      .enable (enable_decoder_in),
      .d_in   (encoder_o_reg),
      .d_out  (decoder_o)   );

endmodule
