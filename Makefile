#!/usr/bin/make -f
build:
	./fw-data-convert > fw-data.sh
clean:
	-rm -rf fw-data.sh
