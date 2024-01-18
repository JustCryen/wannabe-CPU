#! /bin/bash

cd output
binfile=rom_prog.bin
bitlength=24
filelength=24

# Remove comments
sed 's/\/\/.*//g;w rom_prog.bin' $(basename $1) > /dev/null

# Translate opcodes
sed -i   's/NOP/00000 000 0000 0000 0000 0000/g' $binfile
sed -i   's/XOR/00001 000/g'	$binfile
sed -i    's/OR/00010 000/g'	$binfile
sed -i   's/AND/00011 000/g'	$binfile
sed -i 's/SUB R/00100 000 R/g'	$binfile #ADD1
sed -i 's/ADD R/00101 000 R/g'	$binfile #ADD1
sed -i    's/RR/00110 000 0000 0000 0000 0000/g'	$binfile
sed -i    's/RL/00111 000 0000 0000 0000 0000/g'	$binfile
sed -i   's/DEC/01000 000/g'	$binfile
sed -i   's/INC/01001 000/g'	$binfile
sed -i 's/LD  R/01010 000 R/g'	$binfile
sed -i    's/ST/01011 000/g'	$binfile
sed -i   's/NOT/01100 000/g'	$binfile
sed -i   's/RST/01111 000 0000 0000 0000 0000/g' $binfile

sed -i 's/JEZ #/10000 000 #/g'	$binfile
sed -i 's/JNZ #/10001 000 #/g'	$binfile
sed -i 's/JLZ #/10010 000 #/g'	$binfile
sed -i 's/JGZ #/10011 000 #/g'	$binfile
sed -i 's/SUB #/10100 000 #/g'	$binfile #ADDr
sed -i 's/ADD #/10101 000 #/g'	$binfile #ADDr
sed -i    's/SR/10110 000 0000 0000 0000 0000/g'	$binfile
sed -i    's/SL/10111 000 0000 0000 0000 0000/g'	$binfile


sed -i 's/JMP #/11000 000 #/g'	$binfile
sed -i 's/LD  #/11010 000 #/g'	$binfile

sed -i 's/LD  b/01010 000 /g'	$binfile

# Registers
sed -i 's/R0/000 0 0000 0000 0000/g' $binfile
sed -i 's/R1/001 0 0000 0000 0000/g' $binfile
sed -i 's/R2/010 0 0000 0000 0000/g' $binfile
sed -i 's/R3/011 0 0000 0000 0000/g' $binfile
sed -i 's/R4/100 0 0000 0000 0000/g' $binfile
sed -i 's/R5/101 0 0000 0000 0000/g' $binfile
sed -i 's/R6/110 0 0000 0000 0000/g' $binfile
sed -i 's/R7/111 0 0000 0000 0000/g' $binfile

# Binary numbers
sed -i 's/#10/0000 0000 0000 1010/g' $binfile
sed -i 's/#11/0000 0000 0000 1011/g' $binfile
sed -i 's/#12/0000 0000 0000 1100/g' $binfile
sed -i 's/#13/0000 0000 0000 1101/g' $binfile
sed -i 's/#14/0000 0000 0000 1110/g' $binfile
sed -i 's/#15/0000 0000 0000 1111/g' $binfile
sed -i  's/#0/0000 0000 0000 0000/g' $binfile
sed -i  's/#1/0000 0000 0000 0001/g' $binfile
sed -i  's/#2/0000 0000 0000 0010/g' $binfile
sed -i  's/#3/0000 0000 0000 0011/g' $binfile
sed -i  's/#4/0000 0000 0000 0100/g' $binfile
sed -i  's/#5/0000 0000 0000 0101/g' $binfile
sed -i  's/#6/0000 0000 0000 0110/g' $binfile
sed -i  's/#7/0000 0000 0000 0111/g' $binfile
sed -i  's/#8/0000 0000 0000 1000/g' $binfile
sed -i  's/#9/0000 0000 0000 1001/g' $binfile

sed -i 's/#-10/1111 1111 1111 0110/g' $binfile
sed -i 's/#-11/1111 1111 1111 0101/g' $binfile
sed -i 's/#-12/1111 1111 1111 0100/g' $binfile
sed -i 's/#-13/1111 1111 1111 0011/g' $binfile
sed -i 's/#-14/1111 1111 1111 0010/g' $binfile
sed -i 's/#-15/1111 1111 1111 0001/g' $binfile
sed -i 's/#-16/1111 1111 1111 0000/g' $binfile
sed -i  's/#-1/1111 1111 1111 1111/g' $binfile
sed -i  's/#-2/1111 1111 1111 1110/g' $binfile
sed -i  's/#-3/1111 1111 1111 1101/g' $binfile
sed -i  's/#-4/1111 1111 1111 1100/g' $binfile
sed -i  's/#-5/1111 1111 1111 1011/g' $binfile
sed -i  's/#-6/1111 1111 1111 1010/g' $binfile
sed -i  's/#-7/1111 1111 1111 1001/g' $binfile
sed -i  's/#-8/1111 1111 1111 1000/g' $binfile
sed -i  's/#-9/1111 1111 1111 0111/g' $binfile

# Hex numbers
sed -i 's/0x0/0000 0000 0000 0000/g' $binfile
sed -i 's/0x1/0000 0000 0000 0001/g' $binfile
sed -i 's/0x2/0000 0000 0000 0010/g' $binfile
sed -i 's/0x3/0000 0000 0000 0011/g' $binfile
sed -i 's/0x4/0000 0000 0000 0100/g' $binfile
sed -i 's/0x5/0000 0000 0000 0101/g' $binfile
sed -i 's/0x6/0000 0000 0000 0110/g' $binfile
sed -i 's/0x7/0000 0000 0000 0111/g' $binfile
sed -i 's/0x8/0000 0000 0000 1000/g' $binfile
sed -i 's/0x9/0000 0000 0000 1001/g' $binfile
sed -i 's/0xA/0000 0000 0000 1010/g' $binfile
sed -i 's/0xB/0000 0000 0000 1011/g' $binfile
sed -i 's/0xC/0000 0000 0000 1100/g' $binfile
sed -i 's/0xD/0000 0000 0000 1101/g' $binfile
sed -i 's/0xE/0000 0000 0000 1110/g' $binfile
sed -i 's/0xF/0000 0000 0000 1111/g' $binfile

# Remove whitespace and empty newlines
sed -i 's/[[:space:]]//g'	$binfile
sed -i '/^$/d'	$binfile

# Quick info
linecount=$(wc -l $binfile | sed "s/\ $binfile//g")
bitcount=$(wc -L $binfile | sed "s/\ $binfile//g")

echo "Generated file:"
cat $binfile
echo -e "\nLines count:\t $linecount / $filelength" 
echo -e "Max line length: $bitcount / $bitlength"

padding=$(expr $filelength - $linecount)
for (( i=$padding; i>0; i-- ))
do
	echo 000000000000000000000000 >> $binfile
done
