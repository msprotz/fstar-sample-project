all: impl1.a impl2.a

%.a: %/*
	krml -tmpdir $@.out -drop FStar -drop Prims -skip-linking -I $* \
	  $(filter %.fst,$^) -verbose -I lib
	ar -r $@ $*.out/*.o

main1.exe: Main1.fst impl1.a
	krml -tmpdir $@.out -skip-linking -I impl1 -I impl2 -I lib $< \
	  -I impl1.a.out -add-include '"Impl1.h"' \
	  -skip-linking -no-prefix Main1 -verbose
	$(CC) impl1.a lib/lib.c main1.exe.out/main1.o -o $@

.PHONY: clean
clean:
	rm -rf *.a *.out
