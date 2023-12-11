#! /bin/bash

cd output
# Remove comments
sed 's/\/\/.*//g;w rom_prog.bin' rom_prog.asm > /dev/null

# Translate opcodes
sed -i   's/NOT/00000 000/g' rom_prog.bin
sed -i   's/XOR/00001 000/g' rom_prog.bin
sed -i    's/OR/00010 000/g' rom_prog.bin
sed -i   's/AND/00011 000/g' rom_prog.bin
sed -i   's/SUB/00100 000/g' rom_prog.bin
sed -i 's/ADD R/00101 000 R/g'	rom_prog.bin #ADD1
sed -i    's/RR/00110 000/g' rom_prog.bin
sed -i    's/RL/00111 000/g' rom_prog.bin
sed -i   's/DEC/01000 000/g' rom_prog.bin
sed -i   's/INC/01001 000/g' rom_prog.bin
sed -i 's/LD  R/01010 000 R/g' rom_prog.bin
sed -i    's/ST/01011 000/g' rom_prog.bin
sed -i   's/NOP/01100 000 0000 0000 0000 0000/g' rom_prog.bin
sed -i   's/RST/01111 000/g' rom_prog.bin

sed -i 's/ADD #/10101 000 #/g'	rom_prog.bin #ADDr
#sed -i 's/ST  #/11011 000 #/g' rom_prog.bin
sed -i 's/LD  #/11010 000 #/g' rom_prog.bin
sed -i 's/LD  b/01010 000 /g' rom_prog.bin


# Registers
sed -i 's/R0/000 0 0000 0000 0000/g' rom_prog.bin
sed -i 's/R1/001 0 0000 0000 0000/g' rom_prog.bin
sed -i 's/R2/010 0 0000 0000 0000/g' rom_prog.bin
sed -i 's/R3/011 0 0000 0000 0000/g' rom_prog.bin
sed -i 's/R4/100 0 0000 0000 0000/g' rom_prog.bin
sed -i 's/R5/101 0 0000 0000 0000/g' rom_prog.bin
sed -i 's/R6/110 0 0000 0000 0000/g' rom_prog.bin
sed -i 's/R7/111 0 0000 0000 0000/g' rom_prog.bin

# Binary numbers
sed -i  's/#0/0000 0000 0000 0000/g' rom_prog.bin
sed -i  's/#1/0000 0000 0000 0001/g' rom_prog.bin
sed -i  's/#2/0000 0000 0000 0010/g' rom_prog.bin
sed -i  's/#3/0000 0000 0000 0011/g' rom_prog.bin
sed -i  's/#4/0000 0000 0000 0100/g' rom_prog.bin
sed -i  's/#5/0000 0000 0000 0101/g' rom_prog.bin
sed -i  's/#6/0000 0000 0000 0110/g' rom_prog.bin
sed -i  's/#7/0000 0000 0000 0111/g' rom_prog.bin
sed -i  's/#8/0000 0000 0000 1000/g' rom_prog.bin
sed -i  's/#9/0000 0000 0000 1001/g' rom_prog.bin
sed -i 's/#10/0000 0000 0000 1010/g' rom_prog.bin
sed -i 's/#11/0000 0000 0000 1011/g' rom_prog.bin
sed -i 's/#12/0000 0000 0000 1100/g' rom_prog.bin
sed -i 's/#13/0000 0000 0000 1101/g' rom_prog.bin
sed -i 's/#14/0000 0000 0000 1110/g' rom_prog.bin
sed -i 's/#15/0000 0000 0000 1111/g' rom_prog.bin

# Hex numbers
sed -i 's/0x0/0000 0000 0000 0000/g' rom_prog.bin
sed -i 's/0x1/0000 0000 0000 0001/g' rom_prog.bin
sed -i 's/0x2/0000 0000 0000 0010/g' rom_prog.bin
sed -i 's/0x3/0000 0000 0000 0011/g' rom_prog.bin
sed -i 's/0x4/0000 0000 0000 0100/g' rom_prog.bin
sed -i 's/0x5/0000 0000 0000 0101/g' rom_prog.bin
sed -i 's/0x6/0000 0000 0000 0110/g' rom_prog.bin
sed -i 's/0x7/0000 0000 0000 0111/g' rom_prog.bin
sed -i 's/0x8/0000 0000 0000 1000/g' rom_prog.bin
sed -i 's/0x9/0000 0000 0000 1001/g' rom_prog.bin
sed -i 's/0xA/0000 0000 0000 1010/g' rom_prog.bin
sed -i 's/0xB/0000 0000 0000 1011/g' rom_prog.bin
sed -i 's/0xC/0000 0000 0000 1100/g' rom_prog.bin
sed -i 's/0xD/0000 0000 0000 1101/g' rom_prog.bin
sed -i 's/0xE/0000 0000 0000 1110/g' rom_prog.bin
sed -i 's/0xF/0000 0000 0000 1111/g' rom_prog.bin

# Remove whitespace and empty newlines
sed -i 's/[[:space:]]//g'  rom_prog.bin
sed -i '/^$/d' rom_prog.bin

# Quick info
linecount=$(wc -l rom_prog.bin | sed 's/rom_prog.bin//g')
linelength=$(wc -L rom_prog.bin | sed 's/rom_prog.bin//g')

echo "Generated file:"
cat rom_prog.bin
echo -e "\nLines count:\t $linecount/ 16" 
echo -e "Max line length: $linelength/ 24"
