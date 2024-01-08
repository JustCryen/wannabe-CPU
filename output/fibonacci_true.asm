// load 0 to R0
LD  #0
ST  R0
// load 1 to R1
LD  #1
ST  R1

// -- begin loop --
// add R1 to R0
LD  R0
ADD R1
ST  R2

// overwrite R0 with R1
LD  R1
ST  R0
// overwrite R1 with R0
LD  R2
ST  R1
JMP #4
