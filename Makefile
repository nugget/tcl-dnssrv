PREFIX?=	/usr/local
LIBDIR?=	lib
PROGNAME?=	tcldnssrv

TARGET?=	$(PREFIX)/$(LIBDIR)/$(PROGNAME)

TCLSH?=		tclsh

UID?=		root
GID?=		wheel

all:

pkgindex:
	@echo "Generating pkgIndex"
	cd $(TARGET) ; umask 022 ; echo "pkg_mkIndex -direct . *.tcl" | $(TCLSH)

install-lib:
	@echo "Installing $(PROGNAME) to $(TARGET)"
	install -o $(UID) -g $(GID) -m 0755 -d $(TARGET)
	install -o $(UID) -g $(GID) -m 0644 dnssrv.tcl $(TARGET)

install-package: install-lib pkgindex

install: install-package

uninstall:
	@echo "Uninstalling $(PROGNAME)"
	rm -rf $(TARGET)
