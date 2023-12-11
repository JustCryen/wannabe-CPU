//example program
//LD  b 0000 0111 1111 1111
LD  #4  // load 4 to accu
ST  R0  // store previous acc to R0

ADD #2  // add 2 to a current 4
ST  R1  // store result to R1

ADD R0  // add 4 stored in R0 to the current 6
ST  R2  // store result to R2

RR  R1  // rotate right the value in R1
ST  R3  // store result to R3

//Load values stored in all registers
LD  R0
LD  R1
LD  R2
LD  R3
LD  R4
LD  R5
LD  R6
LD  R7
