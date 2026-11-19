# code for CC_alu.v
  ...
     module alu (alu_sel_in,alu_carry_in,alu_a_in,alu_b_in,alu_y_out);

   //Port declarations
   input  [4:0] alu_sel_in;
   input  alu_carry_in;
   input  [7:0] alu_a_in,alu_b_in;
   output [7:0] alu_y_out;

   //Internal variable declaration
   reg [7:0] alu_y_out;
   reg [7:0] logic_unit,arith_unit,alu_noshift;

   always@(*)
      begin

         //Logic Unit
         case(alu_sel_in[1:0])
            2'b00   : logic_unit = alu_a_in & alu_b_in;
            2'b01   : logic_unit = alu_a_in | alu_b_in;
            2'b10   : logic_unit = alu_a_in ^ alu_b_in;
            2'b11   : logic_unit = ~alu_a_in;
            default : logic_unit = 8'bx;
         endcase

        //Arithmetic Unit
        case ({alu_sel_in[1:0],alu_carry_in})
            3'b000   : arith_unit = alu_a_in;
            3'b001   : arith_unit = alu_a_in + 1;
            3'b010   : arith_unit = alu_a_in + alu_b_in;
            3'b011   : arith_unit = alu_a_in + alu_b_in + 1;
            3'b100   : arith_unit = alu_a_in + (~alu_b_in);
            3'b101   : arith_unit = alu_a_in - alu_b_in;
            3'b110   : arith_unit = alu_a_in - 1;
            3'b111   : arith_unit = alu_a_in;
            default  : arith_unit = 8'bx;
         endcase

         //Multiplex between Logic & Arithmetic Units
         if(alu_sel_in[2])
            alu_noshift = logic_unit;
         else
            alu_noshift = arith_unit;

         //Shift Operations
         case (alu_sel_in[4:3])
            2'b00   : alu_y_out = alu_noshift;
            2'b01   : alu_y_out = alu_noshift << 1;
            2'b10   : alu_y_out = alu_noshift >> 1;
            2'b11   : alu_y_out = 8'b0;
            default : alu_y_out = 8'bx;
      endcase
   end

endmodule
...
