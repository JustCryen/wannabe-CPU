# wannabe-CPU
 An early version of a CPU, it's likely a hybrid between CISC and RISC architectures.
 
# building and simulating
 This project is meant to be simulated with iverilog and displayed with gtkwave.

 Included with the project is a [rom_prog.asm](https://github.com/JustCryen/wannabe-CPU/blob/master/output/rom_prog.asm) file, this is the CPUs ROM and it can be assembled using [simple-assembler.sh](https://github.com/JustCryen/wannabe-CPU/blob/master/output/simple-assembler.sh). (depends on `sed`)

 After that's done, to execute the simulation and visualization run the [save](https://github.com/JustCryen/wannabe-CPU/blob/master/output/save) file `./output/save` or manually use `iverilog` and `gtkwave`. 
Keep in mind that testbench uses the LXT2 format instead of the default VCD, this requires an additional `-lxt2` flag in `vvp`.  You'll also need to include every single verilog file located in `src/` and selected testbench from `tb/`.

 All scripts are meant to be executed from the root of the project, not from inside of the output directory.

# tips
 - The project includes [inst_filter.gtkw](https://github.com/JustCryen/wannabe-CPU/blob/master/output/inst_filter.gtkw) file, which can be used in gtkwave to replace 5-bit entries containing opcodes to mnemonic representation of the instruction.
 - Both scripts ([iverilog-run](https://github.com/JustCryen/iverilog-run) and `./output/save`) can be appended with `-q` flag to execute them without launching gtkwave, then an existing gtkwave instance can be refreshed with `CTRL + SHIFT + R`
 - Gtkwave itself can save signal arrangement with `CTRI + S` key combination.
 
# TODO
- [ ] Add carry support
- [x] Add a simple jump 
- [x] Add conditional jump
- [ ] Add relative jump
- [ ] Jumps from register value
- [ ] Add negative numbers (two's complement)
- [ ] Turns out internal RST doesn't work, fix it
- [ ] Move ROM outside of the core.v
- [ ] Add pipeline
