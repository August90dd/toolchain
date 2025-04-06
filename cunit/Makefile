EXEC	:= add_ut
LIBS	:= cunit
CC		:= gcc
CFLAGS	:= 

SRCS := $(wildcard *.c)
OBJS := $(patsubst %.c,%.o,$(SRCS))

.PHONY: clean

all: $(EXEC)

$(EXEC): $(OBJS)
	$(CC) $^ $(addprefix -l,$(LIBS)) -o $@

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f *.o $(EXEC)
