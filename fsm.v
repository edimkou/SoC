// Company: uth university school of engineers
// Engineer: Dimkou Eleni
// 			 Karagiannis Marios
// 			 Lianidis Theodoros 
`timescale 1ns/1ps

module fsm(output reg begin_l,
           output reg begin_ip,
           output reg [31:0] x1,
           output reg [31:0] y1,
           output reg [31:0] z1,
           output reg [31:0] w1,
           output reg [31:0] x2,
           output reg [31:0] y2,
           output reg [31:0] z2,
           output reg [31:0] w2,
           input [31:0] x1in,
           input [31:0] y1in,
           input [31:0] z1in,
           input [31:0] w1in,
           input [31:0] x2in,
           input [31:0] y2in,
           input [31:0] z2in,
           input [31:0] w2in,
           input clock,
           input [3:0] func);

  always @(posedge clock)
   begin
          case (func)
            4'b0000 :
              begin
                x1 <= 32'b0;
                y1 <= 32'b0;
                z1 <= 32'b0;
                w1 <= 32'b0;
                x2 <= 32'b0;
                y2 <= 32'b0;
                z2 <= 32'b0;
                w2 <= 32'b0;
                begin_l <= 1'b0;
                begin_ip <= 1'b0;
              end

            4'b1000 :
              begin
                x1 <= x1in;
                y1 <= y1in;
                z1 <= 32'b0;
                w1 <= 32'b0;
                x2 <= 32'b0;
                y2 <= 32'b0;
                z2 <= 32'b0;
                w2 <= 32'b0;
                begin_l <= 1'b1;
                begin_ip <= 1'b0;
              end
            4'b1010 :
              begin
                x1 <= x1in;
                y1 <= y1in;
                z1 <= z1in;
                w1 <= 32'b0;
                x2 <= 32'b0;
                y2 <= 32'b0;
                z2 <= 32'b0;
                w2 <= 32'b0;
                begin_l <= 1'b1;
                begin_ip <= 1'b0;
                //start = 1'b1;
              end
            4'b1011 :
              begin
                x1 <= x1in;
                y1 <= y1in;
                z1 <= z1in;
                w1 <= w1in;
                x2 <= 32'b0;
                y2 <= 32'b0;
                z2 <= 32'b0;
                w2 <= 32'b0;
                begin_l <= 1'b1;
                begin_ip <= 1'b0;
              end

            4'b1100 :
              begin
                x1 <= x1in;
                y1 <= y1in;
                z1 <= 32'b0;
                w1 <= 32'b0;
                x2 <= x2in;
                y2 <= y2in;
                z2 <= 32'b0;
                w2 <= 32'b0;
                begin_l <= 1'b0;
                begin_ip <= 1'b1;
              end
            4'b1110 :
              begin
                x1 <= x1in;
                y1 <= y1in;
                z1 <= z1in;
                w1 <= 32'b0;
                x2 <= x2in;
                y2 <= y2in;
                z2 <= z2in;
                w2 <= 32'b0;
                begin_l <= 1'b0;
                begin_ip <= 1'b1;
              end
            4'b1111 :
              begin
                x1 <= x1in;
                y1 <= y1in;
                z1 <= z1in;
                w1 <= w1in;
                x2 <= x2in;
                y2 <= y2in;
                z2 <= z2in;
                w2 <= w2in;
                begin_l <= 1'b0;
                begin_ip <= 1'b1;
              end
            default :
            begin
                x1 <= 32'b0;
                y1 <= 32'b0;
                z1 <= 32'b0;
                w1 <= 32'b0;
                x2 <= 32'b0;
                y2 <= 32'b0;
                z2 <= 32'b0;
                w2 <= 32'b0;
                begin_l <= 1'b0;
                begin_ip <= 1'b0;
             end  


        endcase



    end // always

endmodule
