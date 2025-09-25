CFLAGS = -g

refCode: main.c refCode.o
	gcc $(CFLAGS) $^ -o $@

refCode.o: refCode.asm
	nasm -f elf64 $< -F dwarf -o $@

clean:
	rm -f refCode refCode.o


qemu: refCode
	qemu-x86_64 -g 1234 refCode

qemuloop:
	while true; do make qemu; done

gdb: refCode
	gdb -x gdb-commands


docker-build:
	podman build -t vsd-alpine .

docker-run:
	podman run -v $$PWD:/app --rm -it vsd-alpine
