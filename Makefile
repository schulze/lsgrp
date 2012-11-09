# lsgrp - list all the members of a group

include config.mk

SRC = lsgrp.c
OBJ = ${SRC:.c=.o}

all: options lsgrp

options:
	@echo lsgrp build options:
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CC       = ${CC}"

.c.o:
	@echo CC $<
	@${CC} -c ${CFLAGS} $<

${OBJ}: config.mk #util.c

lsgrp: ${OBJ}
	@echo CC -o $@
	@${CC} -o $@ ${OBJ} ${LDFLAGS}

clean:
	@echo cleaning
	@rm -f lsgrp ${OBJ} lsgrp-${VERSION}.tar.gz

dist: clean
	@echo creating dist tarball
	@mkdir -p lsgrp-${VERSION}
	@cp -R LICENSE Makefile README config.mk lsgrp.1 lsgrp.c lsgrp-${VERSION}
	@tar -cf lsgrp-${VERSION}.tar lsgrp-${VERSION}
	@gzip lsgrp-${VERSION}.tar
	@rm -rf lsgrp-${VERSION}

install: all
	@echo installing executable file to ${DESTDIR}${PREFIX}/bin
	@mkdir -p ${DESTDIR}${PREFIX}/bin
	@cp -f lsgrp ${DESTDIR}${PREFIX}/bin
	@chmod 755 ${DESTDIR}${PREFIX}/bin/lsgrp
	@echo installing manual page to ${DESTDIR}${MANPREFIX}/man1
	@mkdir -p ${DESTDIR}${MANPREFIX}/man1
	@sed "s/VERSION/${VERSION}/g" < lsgrp.1 > ${DESTDIR}${MANPREFIX}/man1/lsgrp.1
	@chmod 644 ${DESTDIR}${MANPREFIX}/man1/lsgrp.1

uninstall:
	@echo removing executable file from ${DESTDIR}${PREFIX}/bin
	@rm -f ${DESTDIR}${PREFIX}/bin/lsgrp
	@echo removing manual page from ${DESTDIR}${MANPREFIX}/man1
	@rm -f ${DESTDIR}${MANPREFIX}/man1/lsgrp.1

.PHONY: all options clean dist install uninstall
