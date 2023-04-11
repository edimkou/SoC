// Company: uth university school of engineers
// Engineer: Dimkou Eleni
// 			 Karagiannis Marios
// 			 Lianidis Theodoros 
`timescale 1ns / 1ps

module calculator(
    input wire clk,
    input wire [31:0] x1in,
    input wire [31:0] y1in,
    input wire [31:0] z1in,
    input wire [31:0] w1in,
    input wire [31:0] x2in,
    input wire [31:0] y2in,
    input wire [31:0] z2in,
    input wire [31:0] w2in,
    output reg    [31:0] length_final,
    output reg    [31:0] ipfinal,
    input  wire    [3:0]  func,         // 4-bit FSM, decides function and number of inputs
    output [7:0] overflow);

    wire [31:0] x1squ, y1squ, z1squ, w1squ;
    wire complete_l, complete_ip;
    wire [31:0] sum2d, sum3d, sum4d, prod2d, prod3d, prod4d;
    wire [31:0] x1x2, y1y2, z1z2, w1w2;
    wire  [31:0] x1, x2, y1, y2, z1, z2, w1, w2;
    wire begin_l;
    wire begin_ip;
    wire [31:0] inner_product, length;
    reg [3:0] total_func;

    reg [31:0] x1new, y1new, z1new, w1new;

    wire busy_root;          //useless for the time




//*************** INPUT IS DECIDED FROM A 4-bit FSM **************//
/*
B3_B2_B1_B0
0  X  X  X : Calculator is idle 
1  0  0  0 : Length of a 2d vector
1  0  1  0 : Length of a 3d vector
1  0  1  1 : Length of a 4d vector
1  1  0  0 : Inner Product of two 2d vectors
1  1  1  0 : Inner Product of two 3d vectors
1  1  1  1 : Inner Product of two 4d vectors

Basically, B3: 1 when the calculator performs a function, 0 when not
           B2: 1 when the function is inner product, 0 when length
           B1: 1 when inputs for 3rd dimension are needed, 0 for when not
           B0: 1 when inputs for 4th dimension are needed, 0 for when not
*/

fsm fsm0(begin_l, begin_ip, x1, y1, z1, w1, x2, y2, z2, w2, x1in, y1in, z1in, w1in, x2in, y2in, z2in, w2in, clk, total_func);

// If an input is not needed, it will be replaced with 32'b0
always@(posedge clk) begin
    total_func <= func;
    x1new <= x1;
    y1new <= y1;
    z1new <= z1;
    w1new <= w1;
end


//**************INSTANTIATION OF MODULES THAT WILL BE USED**************//

//These will be used for the length
qmults mult1 (x1, x1new, begin_l, clk, x1squ, complete_l, overflow[0]); //Produces x1^2
qmults mult2 (y1, y1new, begin_l, clk, y1squ, complete_l, overflow[1]); //Produces y1^2
qmults mult3 (z1, z1new, begin_l, clk, z1squ, complete_l, overflow[2]); //Produces z1^2
qmults mult4 (w1, w1new, begin_l, clk, w1squ, complete_l, overflow[3]); //Produces w1^2

qadd add1(x1squ, y1squ, sum2d); //Produces x1^2 + y1^2
qadd add2(z1squ, sum2d, sum3d); //Produces x1^2 + y1^2 + z1^2
qadd add3(w1squ, sum3d, sum4d); //Produces x1^2 + y1^2 + z1^2 + w1^2


root root1(clk, complete_l, busy_root, sum4d, length); //Finally produces the length


//These will be used for the inner product
qmults mult5 (x1, x2, begin_ip, clk, x1x2, complete_ip, overflow[4]); //Produces x1*x2
qmults mult6 (y1, y2, begin_ip, clk, y1y2, complete_ip, overflow[5]); //Produces y1*y2
qmults mult7 (z1, z2, begin_ip, clk, z1z2, complete_ip, overflow[6]); //Produces z1*z2
qmults mult8 (w1, w2, begin_ip, clk, w1w2, complete_ip, overflow[7]); //Produces w1*w2

qadd  add4(x1x2, y1y2, prod2d);        //Produces inner product for 2-d vectors.
qadd  add5(z1z2, prod2d, prod3d);        //Produces inner product for 3-d vectors.
qadd  add6(w1w2, prod3d, inner_product);  //Produces inner product for 4-d vectors.


// Final results
always@(posedge clk) begin
    if(complete_ip && inner_product != 32'b0)
        ipfinal <= inner_product;
    else
        ipfinal <= ipfinal;

    if(complete_l &&  !busy_root)
        length_final <= length;
end


endmodule
