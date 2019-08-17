# Compile the molecular dynamics program

CC = gcc
SRCS = $(wildcard ./*.c)
OBJS = $(patsubst ./%.c, ./%.o, $(SRCS))
EXEC = md
CFLAGS = -Wall
LFLAGS = -lpthread -lm -L/lib -L/usr/lib

all:$(OBJS)
	$(CC) $(OBJS) -o $(EXEC)

%.o:%.c
	$(CC) -c $< -o $@ $(CFLAGS) $(LFLAGS)

.PHONY:clean
clean:
	rm $(OBJS) $(EXEC) -f
