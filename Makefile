ARCHS=amd64 x32 i386 \
	win32 win64 \
	mips mipsel mips64 mips64el \
	illumos-amd64 \
	kfreebsd-amd64 kfreebsd-i386 \
	powerpc ppc64 ppc64el \
	s390x \
	arm64 arm armel armhf \
	sh4 \
	m68k \
	sparc sparc64 \
	alpha
X86=x86_64-linux-gnu
MIPS=mips-linux-gnu
POWERPC=powerpc-linux-gnu
ARM=arm-linux-gnueabihf
SPARC=sparc64-linux-gnu
-include config
all: $(ARCHS:%=arch-test-%)

clean:
	rm -f *.o arch-test-* core *.core

distclean: clean
	rm -f config

DESTDIR=
PREFIX=/usr/local
install: all
	mkdir -p $(DESTDIR)$(PREFIX)/lib/arch-test/
	sed -e "s|^HELPERS.*|HELPERS=$(PREFIX)/lib/arch-test/|" \
		<arch-test >$(DESTDIR)$(PREFIX)/bin/arch-test
	chmod a+x $(DESTDIR)$(PREFIX)/bin/arch-test
	for x in $(ARCHS); do cp -p arch-test-$$x \
		$(DESTDIR)$(PREFIX)/lib/arch-test/$$x;done
	mkdir -p $(DESTDIR)$(PREFIX)/share/man/man1/
	install -p *.1 $(DESTDIR)$(PREFIX)/share/man/man1/

arch-test-amd64: amd64.s
	$(X86)-as --64 $^ -o amd64.o
	$(X86)-ld -melf_x86_64 -s amd64.o -o $@

arch-test-x32: x32.s
	$(X86)-as --x32 $^ -o x32.o
	$(X86)-ld -melf32_x86_64 -s x32.o -o $@

arch-test-i386: i386.s
	$(X86)-as --32 $^ -o i386.o
	$(X86)-ld -melf_i386 -s i386.o -o $@

arch-test-win32: generic.c
	i686-w64-mingw32-gcc $^ -s -o $@

arch-test-win64: generic.c
	x86_64-w64-mingw32-gcc $^ -s -o $@

arch-test-mips: mips.s
	$(MIPS)-as -32 -EB $^ -o mips.o
	$(MIPS)-ld -melf32btsmip -s mips.o -o $@

arch-test-mipsel: mips.s
	$(MIPS)-as -32 -EL $^ -o mipsel.o
	$(MIPS)-ld -melf32ltsmip -s mipsel.o -o $@

arch-test-mips64: mips64.s
	$(MIPS)-as -64 -EB $^ -o mips64.o
	$(MIPS)-ld -melf64btsmip -s mips64.o -o $@

arch-test-mips64el: mips64.s
	$(MIPS)-as -64 -EL $^ -o mips64el.o
	$(MIPS)-ld -melf64ltsmip -s mips64el.o -o $@

arch-test-illumos-amd64: solaris-amd64.s
	$(X86)-as --64 $^ -o illumos-amd64.o
	$(X86)-ld -melf_x86_64 -s illumos-amd64.o -o $@

arch-test-kfreebsd-amd64: solaris-amd64.s
	$(X86)-as --64 $^ -o kfreebsd-amd64.o
	$(X86)-ld -melf_x86_64 -s kfreebsd-amd64.o -o $@
	printf '\t'|dd of=$@ bs=1 count=1 seek=7 conv=notrunc

arch-test-kfreebsd-i386: kfreebsd-i386.s
	$(X86)-as --32 $^ -o kfreebsd-i386.o
	$(X86)-ld -melf_i386 -s kfreebsd-i386.o -o $@
	printf '\t'|dd of=$@ bs=1 count=1 seek=7 conv=notrunc

arch-test-powerpc: powerpc.s
	$(POWERPC)-as -a32 $^ -o powerpc.o
	$(POWERPC)-ld -melf32ppc -s powerpc.o -o $@

arch-test-ppc64: ppc64.s
	$(POWERPC)-as -a64 $^ -o ppc64.o
	$(POWERPC)-ld -melf64ppc -s ppc64.o -o $@

arch-test-ppc64el: ppc64el.s
	powerpc64le-linux-gnu-as -mpower8 $^ -o ppc64el.o
	powerpc64le-linux-gnu-ld -s ppc64el.o -o $@

arch-test-s390x: s390x.s
	s390x-linux-gnu-as $^ -o s390x.o
	s390x-linux-gnu-ld -s s390x.o -o $@

arch-test-arm64: arm64.s
	aarch64-linux-gnu-as $^ -o arm64.o
	aarch64-linux-gnu-ld -s arm64.o -o $@

arch-test-arm: arm.oabi.s
	$(ARM)-as $^ -o arm.o
	$(ARM)-ld -s arm.o -o $@

arch-test-armel: arm.eabi.s
	$(ARM)-as $^ -o armel.o
	$(ARM)-ld -s armel.o -o $@

arch-test-armhf: armhf.s
	$(ARM)-as $^ -o armhf.o
	$(ARM)-ld -s armhf.o -o $@

arch-test-sh4: sh4.s
	sh4-linux-gnu-as $^ -o sh4.o
	sh4-linux-gnu-ld -s sh4.o -o $@

arch-test-m68k: m68k.s
	m68k-linux-gnu-as $^ -o m68k.o
	m68k-linux-gnu-ld -s m68k.o -o $@

arch-test-sparc64: sparc64.s
	$(SPARC)-as --64 $^ -o sparc64.o
	$(SPARC)-ld -melf64_sparc -s sparc64.o -o $@

arch-test-sparc: sparc.s
	$(SPARC)-as --32 $^ -o sparc.o
	$(SPARC)-ld -melf32_sparc -s sparc.o -o $@

arch-test-alpha: alpha.s
	alpha-linux-gnu-as $^ -o alpha.o
	alpha-linux-gnu-ld -s alpha.o -o $@
