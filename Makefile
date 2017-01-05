all: main1.exe main2.exe

# Produce an archive impl1.a from all the implementation files that the
# top-level file Impl1.fst depends on (respectively impl2.a and Impl2.fst)
%.a: %/*
	krml -tmpdir $@.out -drop FStar -drop Prims -skip-linking -I $* \
	  $(filter %.fst,$^) -verbose -I lib
	ar -r $@ $@.out/*.o

# Even though Main1.fst type-checks against Impl1 and Impl2, it really only uses
# Impl1 after partial evaluation, meaning that we can afford to compile impl1.a
# only and then pass it all to Kremlin. Easy!
main1.exe: Main1.fst impl1.a lib/lib.c
	krml -tmpdir $@.out -I impl1 -I impl2 -I lib \
	  -I impl1.a.out -add-include '"Impl1.h"' \
	  -no-prefix Main1 -verbose $^ -o $@

# No luck for Main2: it does not use partial evaluation, meaning that the
# generated C file contains references to symbols from Impl1 and Impl2 -- we
# have to link them both.
main2.exe: Main2.fst impl1.a impl2.a lib/lib.c
	krml -tmpdir $@.out -I impl1 -I impl2 -I lib \
	  -I impl1.a.out -add-include '"Impl1.h"' \
	  -I impl2.a.out -add-include '"Impl2.h"' \
	  -no-prefix Main2 -verbose $^ -o $@

.PHONY: clean
clean:
	rm -rf *.a *.out
