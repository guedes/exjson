EBIN_DIR=ebin

.PHONY: test clean

compile:
	@ mix compile
	@ echo

test:
	@ mix test
	@ echo

clean:
	@ mix clean
	@ echo
