# wannabe-CPU
 An early version of a CPU, it's likely a hybrid between CISC and RISC architectures.
 
# building and simulating
 This project is meant to be simulated with iverilog and displayed with gtkwave.
 My [iverilog-run](https://github.com/JustCryen/iverilog-run) shell script can be used to make creation and execution of the project easier but its [save](https://github.com/JustCryen/wannabe-CPU/blob/master/output/save) file is included with the project and can be executed separately of iverilog-run. (it's a fully functional shell script and a self contained representation of the iverilog-run script)

Included with the project is a [rom_prog.asm](https://github.com/JustCryen/wannabe-CPU/blob/master/output/rom_prog.asm) file, this is the CPUs ROM and it can be assembled using [simple-assembler.sh](https://github.com/JustCryen/wannabe-CPU/blob/master/output/simple-assembler.sh). (depends on `sed`)

All scripts are meant to be executed from the root of the project, not from inside of the output directory.

# tips
 - The project includes [instr_filter.gtkw](https://github.com/JustCryen/wannabe-CPU/blob/master/output/instr_filter.gtkw) file, which can be used in gtkwave to replace 5-bit entries containing opcodes to mnemonic representation of the instruction.
 - Both scripts (`iverilog run` and `./output/save`) can be appended with `-q` flag to execute them without launching gtkwave, then an existing gtkwave instance can be refershed with `CTRL + SHIFT + R`
 - Gtkwave itself can save signal arrangement with `CTRI + S` key combination.
