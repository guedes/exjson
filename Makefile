EBIN_DIR=ebin

.PHONY: test clean

compile: ebin

ebin: lib/*.ex
	@ rm -f ebin/::*.beam
	@ echo Compiling ...
	@ mkdir -p $(EBIN_DIR)
	@ touch $(EBIN_DIR)
	elixirc lib/*/*/*.ex lib/*/*.ex lib/*.ex -o $(EBIN_DIR)
	@ echo

test: compile
	@ echo Running tests ...
	time elixir -pa ebin -r "test/**/*_test.exs"
	@ echo

clean:
	rm -rf $(EBIN_DIR)
	@ echo
