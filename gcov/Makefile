CC = gcc
CFLAGS = -g -fprofile-arcs -ftest-coverage

.PHONY: clean

clean:
	rm -f *.gcno
	rm -f *.gcda
	rm -f *.gcov
	rm -f *.info
	rm -rf result

	rm -f `file * | grep ELF | cut -d: -f1`
	rm -f *~
