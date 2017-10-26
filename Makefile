
# should be the correct path if erlang is installed via apt-get on ubuntu 16
OTPROOT=$(wildcard /usr/lib/erlang/lib/erl_interface-*)

all:	bin/cnodeserver bin/cnodeclient bin/Elixir.Complex.beam

bin/Elixir.Complex.beam: src/complex.ex
	elixirc -o bin $<

bin/%:	src/%.c
	mkdir -p bin
	gcc -o $@ -I$(OTPROOT)/include -L$(OTPROOT)/lib src/complex.c $< -lerl_interface -lei -lpthread -lnsl

clean:
	rm -rf bin

start_client:
	bin/cnodeclient 

start_server:
	bin/cnodeserver 3456

start_elixir:
	echo "run ':complex3.foo(4)' via elixir shell"
	iex --sname e1 --cookie secretcookie -pa bin
