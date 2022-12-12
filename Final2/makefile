CC=gcc
ASM=nasm

all: add.o main

add.o: add.asm
	$(ASM) -f elf64 -o add.o add.asm

main: main.c add.o
	$(CC) -o main main.c add.o

clean:
	rm -f main add.o

run: main
	./main
