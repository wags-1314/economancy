RKT_FILES := $(wildcard *.rkt)

.PHONY: clean

player: $(RKT_FILES)
	raco exe -o player economancy.rkt

clean:
	rm -rf player

