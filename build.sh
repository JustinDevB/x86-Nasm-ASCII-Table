nasm -felf64 $1.s

ld $1.o -o $1

rm $1.o
