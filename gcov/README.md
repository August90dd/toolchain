1) test.gcno                            gcc -fprofile-arcs -ftest-coverage test.c -o test
2) test.gcda                            ./test
                                        ./test 14
3) test.c.gcov                          gcov test.c
4) test.info                            lcov -d . -t 'Test Coverage' -o 'test.info' -b . -c
5) 生成result目录, 其中包含index.html   genhtml -o result test.info
