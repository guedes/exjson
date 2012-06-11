EBIN_DIR=ebin
EXBIN_DIR=exbin

.PHONY: test clean

compile: ebin exbin

exbin: lib/*.ex
	@ rm -f ${EBIN_DIR}/::*.beam
	@ echo Compiling Elixir code ...
	@ mkdir -p ${EBIN_DIR}
	@ touch ${EBIN_DIR}
	elixirc --docs -pa ${EBIN_DIR} lib/*/*/*.ex lib/*/*.ex lib/*.ex -o ${EBIN_DIR}
	@ echo

ebin: src/*.erl
	@ rm -f ${EBIN_DIR}/::*.beam
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
