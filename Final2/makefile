CC=gcc
ASM=nasm

all: add.o main

add.o: add.asm
	$(ASM) -f elf64 -o add.o add.asm

string.o: string.asm
	$(ASM) -f elf64 -o string.o string.asm

main: main.c add.o string.o
	$(CC) -o main main.c add.o string.o

clean:
	rm -f main add.o string.o

run: main
	./main
