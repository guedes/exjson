EBIN_DIR=ebin
EXBIN_DIR=exbin

.PHONY: test clean

compile: ebin exbin

exbin: lib/*.ex
	@ rm -f ${EXBIN_DIR}/::*.beam
	@ echo Compiling Elixir code ...
	@ mkdir -p $(EXBIN_DIR)
	@ touch $(EXBIN_DIR)
	elixirc -pa ${EBIN_DIR} lib/*/*/*.ex lib/*/*.ex lib/*.ex -o $(EXBIN_DIR)
	@ echo

ebin: src/*.erl
	@ rm -f ${EBIN_DIR}/::*.beam
	@ echo Compiling Erlang code ...
	@ mkdir -p $(EBIN_DIR)
	@ touch $(EBIN_DIR)
	erlc -o ${EBIN_DIR} src/*.erl
	@ echo

test: compile
	@ echo Running tests ...
	time elixir -pa ${EXBIN_DIR} -pa ${EBIN_DIR} -r "test/**/*_test.exs"
	@ echo

clean:
	rm -rf $(EBIN_DIR)
	rm -rf $(EXBIN_DIR)
	@ echo
