module car_park_1(
    input clock_in,
    input rst_in,
    input front_sensor,
    input back_sensor,
    input [1:0] password,
   // input [1:0] pass_2,
    output wire G_led,
    output wire R_led
    );
    parameter IDLE = 3'b000, WAIT_PASSWORD = 3'b001, WRONG_PASS = 3'b010, RIGHT_PASS = 3'b011,STOP = 3'b100;
 // Moore FSM : output just depends on the current state
 reg[2:0] current_state, next_state;
 reg[31:0] count =  31'b1;
 reg red_tmp,green_tmp;
 // Next state
 always @(posedge clock_in or negedge rst_in)
 begin
 if(~rst_in) 
 current_state = IDLE;
 else
 current_state = next_state;
 end
 
  
 // change state
// fpga4student.com FPGA projects, Verilog projects, VHDL projects
 always @(*)
 begin
 case(current_state)
 IDLE: begin
         if(front_sensor == 1 && count <10)
 next_state = WAIT_PASSWORD;
 else if (front_sensor == 1 && count  >= 10)
 next_state = STOP;
 else
 next_state = IDLE;
 end
 WAIT_PASSWORD: begin
 
 if(password == 2'b11) begin
 next_state = RIGHT_PASS;

 end
 else
 next_state = WRONG_PASS;
 end

 WRONG_PASS: begin
 if((password==2'b11))
 next_state = RIGHT_PASS;
 else
 next_state = WRONG_PASS;
 end
 
 RIGHT_PASS: begin
 
 count = count +1;
 
 if(front_sensor==1 && back_sensor == 1) begin
 count = count;
 next_state = IDLE;
 end
 else if(front_sensor==0 && back_sensor == 1) begin
 count = count - 1;
 next_state = IDLE;
 end
 else
 next_state = IDLE;
 end
 STOP: begin
 if(back_sensor == 1) begin
 count = count-1;
 next_state = WAIT_PASSWORD;
 end
 else
 next_state = STOP;
 end
 default: next_state = IDLE;
 endcase
 end
 // LEDs and output, change the period of blinking LEDs here
 always @(posedge clock_in) begin 
 case(current_state)
 IDLE: begin
 green_tmp = 1'b0;
 red_tmp = 1'b0;

 end
 WAIT_PASSWORD: begin
 green_tmp = 1'b0;
 red_tmp = 1'b1;
 
 end
 WRONG_PASS: begin
 green_tmp = 1'b0;
 red_tmp = ~red_tmp;

 end
 RIGHT_PASS: begin
 green_tmp = ~green_tmp;
 red_tmp = 1'b0;
 
 end
 STOP: begin
 green_tmp = 1'b0;
 red_tmp = ~red_tmp;
  end
 endcase
 end
 assign R_led = red_tmp  ;
 assign G_led = green_tmp;
endmodule
