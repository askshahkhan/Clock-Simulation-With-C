# CSCI 2021 Project 2 Makefile
# Updated: Fri Oct  8 11:34:47 AM CDT 2021 

AN = p2
CLASS = 2021

# -Wno-comment: disable warnings for multi-line comments, present in some tests
CFLAGS = -Wall -Wno-comment -Werror -g 
CC     = gcc $(CFLAGS)
SHELL  = /bin/bash
CWD    = $(shell pwd | sed 's/.*\///g')

PROGRAMS = \
	clock_main \
	test_clock_update \
	puzzlebox   \


all : $(PROGRAMS)

clean :
	rm -f $(PROGRAMS) *.o

help :
	@echo 'Typical usage is:'
	@echo '  > make                          # build all programs'
	@echo '  > make clean                    # remove all compiled items'
	@echo '  > make zip                      # create a zip file for submission'
	@echo '  > make prob1                    # built targets associated with problem 1'
	@echo '  > make prob1 testnum=5          # run problem 1 test #5 only'
	@echo '  > make test-prob2               # run test for problem 2'
	@echo '  > make test                     # run all tests'


############################################################
# 'make zip' to create p2-code.zip for submission
zip : clean clean-tests
	rm -f $(AN)-code.zip
	cd .. && zip "$(CWD)/$(AN)-code.zip" -r "$(CWD)"
	@echo Zip created in $(AN)-code.zip
	@if (( $$(stat -c '%s' $(AN)-code.zip) > 10*(2**20) )); then echo "WARNING: $(AN)-code.zip seems REALLY big, check there are no abnormally large test files"; du -h $(AN)-code.zip; fi
	@if (( $$(unzip -t $(AN)-code.zip | wc -l) > 256 )); then echo "WARNING: $(AN)-code.zip has 256 or more files in it which may cause submission problems"; fi


################################################################################
# clock problem
prob1 : clock_main test_clock_update

clock_main : clock_main.o clock_sim.o clock_update.o
	$(CC) -o $@ $^

clock_main.o : clock_main.c clock.h
	$(CC) -c $<

clock_sim.o : clock_sim.c clock.h
	$(CC) -c $<

clock_update.o : clock_update.c clock.h
	$(CC) -c $<

test_clock_update : test_clock_update.c clock_sim.o clock_update.o
	$(CC) -o $@ $^

################################################################################
# debugging problem
prob2 : puzzlebox

puzzlebox.o : puzzlebox.c
	$(CC) -c $<

puzzlebox : puzzlebox.o
	$(CC) -o $@ $^

################################################################################
# Testing Targets
test-setup :
	@chmod u+rx testy

test: test-prob1 test-prob2

test-prob1: test-setup prob1
	./testy test_prob1.org $(testnum)

test-prob2 : puzzlebox
	./puzzlebox input.txt

clean-tests : 
	rm -rf test-results/ test_clock_update


