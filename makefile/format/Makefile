EXEC = fmt
CC = gcc
CFLAGS = -Wall -g -std=c99
SRCS := $(wildcard *.c)
OBJS := $(patsubst %.c,%.o,$(SRCS)) 

.PHONY: clean


all: 
	make $(EXEC)

$(EXEC): $(OBJS)
	$(CC) $^ -o $@ 
 
%.o: %.c 
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f *.o $(EXEC)
