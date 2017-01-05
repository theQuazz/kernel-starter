TARGET = kernel.elf

CC = arm-none-eabi-gcc
AS = arm-none-eabi-as
LD = arm-none-eabi-gcc
DM = arm-none-eabi-objdump

CPPFLAGS = -MMD \
	 -MP \
	 -Wall \
	 -Wextra \
	 -Werror \
	 -I.

CFLAGS = --std=c99 \
	-nostdlib \
	-msoft-float \
	-ffreestanding \
	-fno-builtin \
	-fplan9-extensions \
	-fPIC \
	-marm \
	-mcpu=arm1176jzf-s

LDFLAGS = $(CFLAGS) \
	-N \
	-flto \
	-Ttext=0x10000 \
	-nostartfiles \
	-lgcc \
	-L/usr/local/Caskroom/gcc-arm-embedded/5_4-2016q3,20160926/gcc-arm-none-eabi-5_4-2016q3/arm-none-eabi/include

ASM = bootstrap.S
SOURCES = main.c
OBJECTS = $(SOURCES:.c=.o) $(ASM:.S=.o)
DEPENDS = $(OBJECTS:.o=.d)

.PHONY: clean qemu
.SUFFIXES: .elf

$(TARGET): $(OBJECTS)
	$(LD) -o $@ $^ $(LDFLAGS)

qemu: $(TARGET)
	qemu-system-arm -M versatilepb -cpu arm1176 -nographic -kernel $(TARGET)

clean:
	$(RM) ~* $(DEPENDS) $(TARGET) $(OBJECTS) *.map
