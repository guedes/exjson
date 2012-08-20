EBIN_DIR=ebin

.PHONY: test clean

compile: erlang elixir

elixir: lib/*.ex
	@ echo Compiling Elixir code ...
	@ mkdir -p ${EBIN_DIR}
	@ touch ${EBIN_DIR}
	elixirc -pa ${EBIN_DIR} lib/*/*/*.ex lib/*/*.ex lib/*.ex -o ${EBIN_DIR}
	@ echo

erlang: src/*.erl
	@ echo Compiling Erlang code ...
	@ mkdir -p ${EBIN_DIR}
	@ touch ${EBIN_DIR}
	erlc -o ${EBIN_DIR} src/*.erl
	@ echo

test: compile
	@ echo Running tests ...
	time elixir -pa ${EBIN_DIR} -r "test/**/*_test.exs"
	@ echo

clean:
	rm -rf ${EBIN_DIR}
	@ echo
