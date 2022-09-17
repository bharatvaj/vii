# makefile.in is the makefile template for vile on unix systems.
# makefile is generated from makefile.in by running configure.
#
# If you edit makefile, your changes will be lost when you run configure
# again.  See the file INSTALL from instructions on how to configure, make,
# and install vile/xvile.
#
# The command/name/key/function bindings are defined in the file "cmdtbl".
# The mktbls program parses this to produce nebind.h, nename.h, neproto.h and
# nefunc.h, which are used by the rest of the build.
#
# Buffer/window modes are defined in the file "modetbl".
# The mktbls program parses this to produce nemode.h, which is included in
# 'estruct.h'.
#
# The version number is found near the top of edef.h, and is displayed with
# the ":version" command, or by invoking vile with "-V".
#
# Paul Fox
#
# gnu autoconf support by kevin buettner, 5/94
#
# $Header: /usr/build/vile/vile/RCS/makefile.in,v 1.244 2010/06/11 23:32:31 tom Exp $

SHELL		= /bin/sh

#### Start of system configuration section. ####

srcdir = .
srcdir_sl = ./



CC		= gcc
CPP		= gcc -E
LINK		=  $(CC) $(CFLAGS)
INSTALL		= /usr/local/bin/ginstall -c
INSTALL_PROGRAM	= ${INSTALL}
INSTALL_SCRIPT	= ${INSTALL}
INSTALL_DATA	= ${INSTALL} -m 644

EXTRA_CFLAGS	= 
CFLAGS		= -g -O2 $(EXTRA_CFLAGS)
LIBS		=   -ltermcap -lcurses  

LINT		= lint
CTAGS		= ctags
ETAGS		= etags

x		= 
o		= .o

X_LIBS		= 

transform	= s,x,x,
TARGET		= vile
ACTUAL		= `echo $(TARGET)|sed '$(transform)'`

SCREEN		= tcap
PROGRAM		= $(TARGET)$x

AWK		= gawk
PERL		= 
PERLLIB		= 
INSTALL_PL_EXE	= $(SHELL) $(srcdir)/sinstall.sh $(PERL) $(INSTALL_PROGRAM)
INSTALL_MODULE	= $(SHELL) $(srcdir)/sinstall.sh $(PERL) $(INSTALL_DATA)

prefix		= /usr/local
exec_prefix	= ${prefix}

manext		= 1
libdir		= ${exec_prefix}/lib
bindir		= ${exec_prefix}/bin
datadir		= ${prefix}/share/vile
docdir		= $(datadir)/doc
htmldir		= $(datadir)/html
perldir		= $(datadir)/perl
mandir		= ${prefix}/man/man$(manext)
appsdir		= 
icondir		= 

#### End of system configuration section. ####

LN_S		= ln -s
RM		= rm -f
MAKE_RECUR	=  prefix=$(prefix) DESTDIR=$(DESTDIR)

CLASS		= XVile
ICON		= vile
ICON_SUFFIX	= 
QUOTDEFS	= \
		-DPROGRAM_NAME=\"$(TARGET)\" \
		-DVILE_ICON=\"icons/$(ICON)$(ICON_SUFFIX)\" \
		-DVILE_LIBDIR_PATH=\"'$(libdir)/vile'\" \
		-DVILE_STARTUP_PATH=\"'$(datadir)'\"
CPPFLAGS	= -I. -I$(srcdir) \
		-DHAVE_CONFIG_H -I/usr/local/opt/opencv@3/include  -D_DARWIN_C_SOURCE

LDFLAGS		=  -L/usr/local/opt/opencv@3/lib 

BINDIR		= $(DESTDIR)$(bindir)
DATADIR		= $(DESTDIR)$(datadir)
DOCDIR		= $(DESTDIR)$(docdir)
HTMLDIR		= $(DESTDIR)$(htmldir)
PERLDIR		= $(DESTDIR)$(perldir)
MANDIR		= $(DESTDIR)$(mandir)
APPSDIR		= $(DESTDIR)$(appsdir)
ICONDIR		= $(DESTDIR)$(icondir)

INSTALL_DIRS    = $(BINDIR) $(DATADIR) $(DOCDIR) $(MANDIR) 

.SUFFIXES: .c .i .cpp .rc $o

.c.i:
	@echo compiling $<
	@$(CPP) -C $(CPPFLAGS) $(QUOTDEFS) $< >$@
.c$o .cpp$o:
	@echo compiling $<
	@$(CC) -c $(CPPFLAGS) $(QUOTDEFS) $(CFLAGS) -DHELP_LOC=\"$(datadir)\" $<

.rc.o:
	windres $(QUOTDEFS) $< $@
# All of the makefiles which should be preserved and distributed
UNIXMAKIN = makefile.in				# for use with configure
VMSMAK = descrip.mms vmsbuild.com		# on VMS
DJGPPMAK = makefile.djg				# on DOS, DJGCC v1.09
NTMAK = makefile.wnt				# on Windows/NT
BCCNTMAK = makefile.blc				# Borland C on Windows/NT
OS2MAK = makefile.icc				# OS/2, (IBM C Set ++ 2.x)

MAKFILES = \
	$(UNIXMAKIN) \
	$(VMSMAK) \
	$(DJGPPMAK) \
	$(BORMAK) \
	$(NTMAK) \
	$(BCCNTMAK) \
	$(OS2MAK)

ALLTOOLS = $(MAKFILES) mktbls.c cmdtbl modetbl \
	configure config_h.in \
	install-sh \
	configure.in aclocal.m4

# these are normal editable headers
HDRS = \
	api.h \
	blist.h \
	btree.h \
	chgdfunc.h \
	dirstuff.h \
	edef.h \
	estruct.h \
	os2keys.h \
	plugin.h \
	proto.h \
	pscreen.h \
	tcap.h \
	trace.h \
	vl_alloc.h \
	vl_ctype.h \
	vl_regex.h \
	vl_stdio.h

SCREENS = \
	ansi.c \
	borland.c \
	ntconio.c \
	ntwinio.c \
	os2vio.c \
	tcap.c \
	vmsvt.c \
	x11.c

# other source code, some used in other makefiles, some useful tools,
#  some possibly obsolete
PERL_SRC = \
	$(srcdir)/perl/Breadcrumbs.pm \
	$(srcdir)/perl/CaptHook.pm \
	$(srcdir)/perl/Glob2re.pm \
	$(srcdir)/perl/Help.pm \
	$(srcdir)/perl/Vile.pm \
	$(srcdir)/perl/Vile/Exporter.pm \
	$(srcdir)/perl/Vile/Manual.pm \
	$(srcdir)/perl/Vileserv.pm \
	$(srcdir)/perl/Visit.pm \
	$(srcdir)/perl/capture.pm \
	$(srcdir)/perl/dict.pm \
	$(srcdir)/perl/directory.pm \
	$(srcdir)/perl/dirlist.pm \
	$(srcdir)/perl/gdb.pm \
	$(srcdir)/perl/hgrep.pm \
	$(srcdir)/perl/lock.pm \
	$(srcdir)/perl/man.pm \
	$(srcdir)/perl/mime.pl \
	$(srcdir)/perl/plugins.pl \
	$(srcdir)/perl/search.pm \
	$(srcdir)/perl/shell.pm \
	$(srcdir)/perl/spell.pm \
	$(srcdir)/perl/vileget \
	$(srcdir)/perl/winops.pm

MACRO_SRC = \
	$(srcdir)/macros/color-ls.rc \
	$(srcdir)/macros/dates.rc \
	$(srcdir)/macros/digraphs.rc \
	$(srcdir)/macros/gnugpg.rc \
	$(srcdir)/macros/loaderrs.rc \
	$(srcdir)/macros/manpage.rc \
	$(srcdir)/macros/modes.rc \
	$(srcdir)/macros/palettes.rc \
	$(srcdir)/macros/pictmode.rc \
	$(srcdir)/macros/search.rc \
	$(srcdir)/macros/shifts.rc \
	$(srcdir)/macros/showeach.rc \
	$(srcdir)/macros/vileinit.rc \
	$(srcdir)/macros/vileperl.rc \
	$(srcdir)/macros/which.rc

OTHERSRC = \
	djhandl.c \
	gppconio.c \
	os2pipe.c \
	vms2unix.c \
	vmspipe.c

# documentation
PLAINDOCS = \
	doc/Vileserv.doc \
	doc/config.doc \
	doc/dir.doc \
	doc/filters.doc \
	doc/macros.doc \
	doc/menus.doc \
	doc/modes.doc \
	doc/oleauto.doc \
	doc/perl.doc \
	doc/visvile.doc \
	vile.1 \
	vile.hlp

# corresponding documentation
HTMLDOCS =	\
	doc/Vileserv.html \
	doc/config.html \
	doc/dir.html \
	doc/filters.html \
	doc/macros.html \
	doc/menus.html \
	doc/modes.html \
	doc/oleauto.html \
	doc/perl.html \
	doc/vile-hlp.html \
	doc/vile-man.html \
	doc/vile-toc.html \
	doc/visvile.html

# miscellaneous text files
TEXTFILES = README README.PC \
	INSTALL CHANGES \
	CHANGES.R7 CHANGES.R6 CHANGES.R5 CHANGES.R4 CHANGES.R3 \
	buglist revlist patchlev.h COPYING

VILESRC = main.c api.c basic.c bind.c btree.c btree.c buffer.c csrch.c \
	display.c dumbterm.c eval.c exec.c externs.c fences.c file.c \
	filec.c fileio.c finderr.c glob.c globals.c \
	history.c input.c insert.c isearch.c itbuff.c lckfiles.c line.c map.c \
	modes.c msgs.c npopen.c nullterm.c oneliner.c opers.c path.c random.c \
	regexp.c region.c search.c select.c spawn.c statevar.c tags.c \
	tbuff.c termio.c ucrypt.c undo.c vl_ctype.c version.c \
	watch.c window.c word.c wordmov.c xterm.c

ALLSRC = $(VILESRC) $(SCREENS) $(OTHERSRC) $(HDRS)

# this is for work-in-progress files being shared among developers
#  which don't need to go into general releases yet.
DEVELOPER_ONLY = \
	trace.c trace.h \
	fakevms.c fakevms.h

# these are the files that go to everyone
DISTFILES = $(ALLTOOLS) $(ALLSRC) $(PLAINDOCS) $(HTMLDOCS) $(TEXTFILES)

# these are the files that go to coders
DEV_DISTFILES = $(DISTFILES) $(DEVELOPER_ONLY)

MKTBLS = ./mktbls$x

# Generated header-files, e.g., nemodes.h
BUILTHDRS = nebind.h neproto.h neexec.h nefunc.h nemode.h nename.h nevars.h nefkeys.h nefsms.h

# Generated source-files, e.g., perl.c
BUILTSRCS = 

# built-in filters, if any
BUILTLIBS = 

# The following are optional (non-core):
#	api.o
#	btree.o
#	builtflt.o
#	history.o
#	isearch.o
#	npopen.o
#	select.o
#	spawn.o
#	statevar.o
#	trace.o
#	ucrypt.o
#	xterm.o
OBJ =	$(SCREEN)$o \
	main$o basic$o bind$o blist$o buffer$o csrch$o \
	display$o dumbterm$o eval$o exec$o externs$o fences$o file$o \
	filec$o fileio$o finderr$o glob$o globals$o \
	input$o insert$o itbuff$o lckfiles$o line$o map$o \
	modes$o msgs$o nullterm$o oneliner$o opers$o path$o random$o \
	regexp$o region$o search$o tags$o \
	tbuff$o termio$o undo$o version$o vl_ctype$o \
	watch$o window$o word$o wordmov$o 
OBJ2 =	

# This should be "$(OBJ:$o=.c)", but IRIX64's make (and some not very old
# BSD-makes) cannot handle it.
SRC =	$(OBJ:.o=.c)

ALL =	$(PROGRAM)

#all \
#install-full \
#install :: $(BUILTHDRS)
#	cd filters && $(MAKE) $(MAKE_RECUR) $@

all ::	$(ALL)

sources : $(BUILTHDRS)

filters/libvlflt.a : $(BUILTHDRS)
	cd filters && $(MAKE) $(MAKE_RECUR) libvlflt.a

$(PROGRAM): $(BUILTHDRS) $(OBJ) $(OBJ2) $(BUILTLIBS)
	- mv $(PROGRAM) o$(PROGRAM)
	@echo linking $@;$(LINK) $(CFLAGS) $(LDFLAGS) -o $@ $(OBJ) $(OBJ2) $(X_LIBS) $(LIBS)

vile.man: vile.1
	nroff -man vile.1 | col -b >vile.man

vile-perl-api.pod: perl.xs
	perl -lne 'print if s/^\s{1,2}#\s{0,1}//' $(srcdir)/perl.xs > $@

vile-perl-api.doc: vile-perl-api.pod
	pod2text vile-perl-api.pod > $@

vile-perl-api.html: vile-perl-api.pod
	pod2html vile-perl-api.pod > $@

vile-perl-api.man: vile-perl-api.pod
	pod2man vile-perl-api.pod > $@

nebind.h \
nefkeys.h \
neexec.h \
nefunc.h \
neproto.h :	nename.h

nename.h :	cmdtbl $(MKTBLS)
	$(MKTBLS) $(srcdir)/cmdtbl

nefsms.h \
nevars.h :	nemode.h

nemode.h:	modetbl $(MKTBLS)
	$(MKTBLS) $(srcdir)/modetbl

builtflt$o :	builtflt.h

builtflt.h :
	$(AWK) -f $(srcdir)/filters/mk-0th.awk <$(srcdir)/filters/genmake.mak static="none" dynamic="none" >$@

$(MKTBLS):  $(srcdir)/mktbls.c
	@echo linking $@;$(CC) $(CPPFLAGS) $(CFLAGS) $(LDFLAGS) \
	    -o $(MKTBLS)  $(srcdir)/mktbls.c

check: $(PROGRAM)
	@echo Sorry, no batch tests available.

INSTALL_DOC_FILES = \
	$(DOCDIR)/Vileserv.doc \
	$(DOCDIR)/config.doc \
	$(DOCDIR)/dir.doc \
	$(DOCDIR)/filters.doc \
	$(DOCDIR)/macros.doc \
	$(DOCDIR)/menus.doc \
	$(DOCDIR)/modes.doc \
	$(DOCDIR)/oleauto.doc \
	$(DOCDIR)/perl.doc \
	$(DOCDIR)/visvile.doc

INSTALL_HTML_FILES = \
	$(HTMLDIR)/vile-hlp.html \
	$(HTMLDIR)/vile-toc.html \
	$(HTMLDIR)/Vileserv.html \
	$(HTMLDIR)/config.html \
	$(HTMLDIR)/dir.html \
	$(HTMLDIR)/filters.html \
	$(HTMLDIR)/macros.html \
	$(HTMLDIR)/menus.html \
	$(HTMLDIR)/modes.html \
	$(HTMLDIR)/oleauto.html \
	$(HTMLDIR)/perl.html \
	$(HTMLDIR)/visvile.html

INSTALL_MACRO_FILES = \
	$(DATADIR)/color-ls.rc \
	$(DATADIR)/dates.rc \
	$(DATADIR)/digraphs.rc \
	$(DATADIR)/gnugpg.rc \
	$(DATADIR)/loaderrs.rc \
	$(DATADIR)/manpage.rc \
	$(DATADIR)/modes.rc \
	$(DATADIR)/palettes.rc \
	$(DATADIR)/pictmode.rc \
	$(DATADIR)/search.rc \
	$(DATADIR)/shifts.rc \
	$(DATADIR)/showeach.rc \
	$(DATADIR)/vileinit.rc \
	$(DATADIR)/vileperl.rc \
	$(DATADIR)/which.rc

INSTALL_PERL_DIRS = $(PERLDIR) $(PERLDIR)/Vile
INSTALL_PERL_FILES = \
	$(BINDIR)/vileget \
	$(PERLDIR)/Breadcrumbs.pm \
	$(PERLDIR)/CaptHook.pm \
	$(PERLDIR)/Glob2re.pm \
	$(PERLDIR)/Help.pm \
	$(PERLDIR)/Vile.pm \
	$(PERLDIR)/Vile/Exporter.pm \
	$(PERLDIR)/Vile/Manual.pm \
	$(PERLDIR)/Vileserv.pm \
	$(PERLDIR)/Visit.pm \
	$(PERLDIR)/capture.pm \
	$(PERLDIR)/dict.pm \
	$(PERLDIR)/directory.pm \
	$(PERLDIR)/dirlist.pm \
	$(PERLDIR)/gdb.pm \
	$(PERLDIR)/hgrep.pm \
	$(PERLDIR)/lock.pm \
	$(PERLDIR)/man.pm \
	$(PERLDIR)/mime.pl \
	$(PERLDIR)/plugins.pl \
	$(PERLDIR)/search.pm \
	$(PERLDIR)/shell.pm \
	$(PERLDIR)/spell.pm \
	$(PERLDIR)/winops.pm


INSTALL_X_FILES = \
	$(BINDIR)/lxvile \
	$(BINDIR)/lxvile-fonts \
	$(BINDIR)/uxvile \
	$(BINDIR)/xshell.sh \
	$(DATADIR)/vilemenu.rc

INSTALL_FILES = \
	$(INSTALL_MACRO_FILES) \
	$(DATADIR)/vile.hlp 

USE_SYMLINK = test NONE != NONE

NAME_OF_ACTUAL = $(ACTUAL)$x
NAME_OF_PAGER  = $(ACTUAL)-pager

LINK_TO_ACTUAL = NONE
LINK_TO_PAGER  = NONE-pager

PATH_OF_ACTUAL = $(BINDIR)/$(ACTUAL)$x
PATH_OF_PAGER  = $(BINDIR)/$(NAME_OF_PAGER)

install-bin \
install-full \
install :: \
		$(INSTALL_DIRS) \
		$(INSTALL_FILES) \
		$(PROGRAM) \
		$(srcdir)/macros/vile-pager
	@echo "** installing $(NAME_OF_ACTUAL)"
	$(INSTALL_PROGRAM) $(PROGRAM) $(PATH_OF_ACTUAL)
	@-$(SHELL) -c "if $(USE_SYMLINK) ; then \
		cd $(BINDIR) ; \
		rm -f $(LINK_TO_ACTUAL) ; \
		$(LN_S) $(NAME_OF_ACTUAL) $(LINK_TO_ACTUAL) ; \
		echo '... created symbolic link:' ; \
		ls -l $(NAME_OF_ACTUAL) $(LINK_TO_ACTUAL) ; \
	fi"

	@echo "** installing $(NAME_OF_PAGER)"
	@sed -e 's/=vile$$/='$(ACTUAL)'/' $(srcdir)/macros/vile-pager >$(PATH_OF_PAGER)
	@chmod 755 $(PATH_OF_PAGER)
	@-$(SHELL) -c "if $(USE_SYMLINK) ; then \
		cd $(BINDIR); \
		rm -f $(LINK_TO_PAGER) ; \
		$(LN_S) $(NAME_OF_PAGER) $(LINK_TO_PAGER) ; \
		echo '... created symbolic link:' ; \
		ls -l $(NAME_OF_PAGER) $(LINK_TO_PAGER) ; \
	fi"

	@echo 'Completed install of program.'

install-man \
install :: $(MANDIR)
	$(INSTALL_DATA)		$(srcdir)/vile.1 $(MANDIR)/$(TARGET).$(manext)

install-doc :		$(DOCDIR)		$(INSTALL_DOC_FILES)

install-html :		$(HTMLDIR)		$(INSTALL_HTML_FILES)

install-macros :	$(DATADIR)		$(INSTALL_MACRO_FILES)

install-perl :		$(INSTALL_PERL_DIRS)	$(INSTALL_PERL_FILES)

installdirs:		$(INSTALL_DIRS)

uninstall-bin \
uninstall ::
	@-$(SHELL) -c "if $(USE_SYMLINK) ; then cd $(BINDIR) && rm -f $(LINK_TO_ACTUAL) ; fi"
	@-$(SHELL) -c "if $(USE_SYMLINK) ; then cd $(BINDIR) && rm -f $(LINK_TO_PAGER) ; fi"
	@- $(RM) $(INSTALL_FILES) $(PATH_OF_ACTUAL) $(PATH_OF_PAGER)
	@echo 'Completed uninstall of program.'

uninstall-man \
uninstall ::
	- $(RM) $(MANDIR)/$(TARGET).$(manext)

uninstall-doc :
	- $(RM) $(INSTALL_DOC_FILES)

uninstall-html :
	- $(RM) $(INSTALL_HTML_FILES)

uninstall-macros :
	- $(RM) $(INSTALL_MACRO_FILES)

uninstall-perl :
	- $(RM) $(INSTALL_PERL_FILES)

################################################################################
#install \
#install-app \
#install-full :: $(APPSDIR)
#	@echo installing $(APPSDIR)/$(CLASS)
#	@sed -e s/XVile/$(CLASS)/ $(srcdir)/macros/XVile.ad >XVile.tmp
#	@$(INSTALL_DATA) XVile.tmp $(APPSDIR)/$(CLASS)
#	@echo installing $(APPSDIR)/UXVile
#	@sed -e s/XVile/$(CLASS)/ $(srcdir)/macros/UXVile.ad >XVile.tmp
#	@$(INSTALL_DATA) XVile.tmp $(APPSDIR)/UXVile
#	@rm -f XVile.tmp
#	@echo "... installed app-defaults"

#install \
#install-icon \
#install-full :: $(ICONDIR)
#	@$(INSTALL_DATA) $(srcdir)/icons/$(ICON)$(ICON_SUFFIX) $(ICONDIR)
#	@echo "... installed icons"
################################################################################
#uninstall \
#uninstall-app \
#uninstall-full ::
#	-$(RM) $(APPSDIR)/$(CLASS)
#	-$(RM) $(APPSDIR)/UXVile

#uninstall \
#uninstall-icon \
#uninstall-full ::
#	-$(RM) $(ICONDIR)/$(ICON)$(ICON_SUFFIX)
################################################################################
# Desktop-utils does not provide an uninstall, and is not uniformly available.
#DESKTOP_FLAGS = --vendor=dickey 
#install-desktop \
#install-full ::
#	desktop-file-install $(DESKTOP_FLAGS) macros/lxvile.desktop
#	desktop-file-install $(DESKTOP_FLAGS) macros/uxvile.desktop
#	desktop-file-install $(DESKTOP_FLAGS) macros/xvile.desktop
################################################################################

# The makefile is technically dependent upon the config.status file, but
# gmake gets overly ambitious and remakes the makefile too often.
makefile: makefile.in
	if test ! -f config.status; then $(SHELL) ./configure; fi
	$(SHELL) ./config.status

# defining this target, though technically (i think) correct, causes
#  the make to fail on machines which don't have autoconf, i.e. most of them.
#configure: configure.in aclocal.m4
#	autoconf

config.status: configure
	$(SHELL) ./config.status --recheck

uninstall \
mostlyclean \
clean \
distclean ::
	- test -f filters/makefile && cd filters && $(MAKE) $(MAKE_RECUR) $@

mostlyclean ::
	- $(RM) *.[oi] o$(PROGRAM) $(BUILTHDRS) $(BUILTSRCS) $(MKTBLS) \
	    builtflt.h core core.* *~ *.tmp *.BAK *.bb* *.da *.gcov

clean :: mostlyclean
	- $(RM) $(ALL)

distclean :: clean
	- $(RM) makefile config.status config.cache config.log config.h
	- test -d filters && rmdir filters

realclean: distclean
	- $(RM) test_*$x
	- $(RM) tags TAGS vile-perl-api.* pod2html-*

lint: $(BUILTHDRS)
	$(LINT) $(CPPFLAGS) $(SRC) $(LIBS)
	$(LINT) $(CPPFLAGS) mktbls.c

TAG_SRC = $(SRC) $(HDRS) $(BUILTSRC) $(BUILTHDRS)

tags:	$(TAG_SRC)
	$(CTAGS) $(TAG_SRC)

TAGS:	$(TAG_SRC)
	$(ETAGS) $(TAG_SRC)

#	 this builds vile-N.Ndev.tar.gz, including all development files
devtarball:	$(DEV_DISTFILES) /tmp/vilevers release_warnings
	echo vile-`cat /tmp/vilevers` > .fname
	rm -rf `cat .fname`
	mkdir `cat .fname`
	SRCDIR=. ;\
	test $(srcdir) = "\@srcdir\@" && SRCDIR=$(srcdir) ;\
	for file in $(DEV_DISTFILES); do \
	  ln $$SRCDIR/$$file `cat .fname` \
	    || { echo copying $$file instead; cp -p $$file `cat .fname`; }; \
	done
#	tar -cf - `cat .fname` | gzip >`cat .fname`dev.tar.gz
	gtar -czf `cat .fname`dev.tar.gz `cat .fname`
	@echo Created `cat .fname`dev.tar.gz
	rm -rf `cat .fname` .fname

#	 this builds vile-N.N.tar.gz, for general release
tarball:	$(DISTFILES) /tmp/vilevers release_warnings
	echo vile-`cat /tmp/vilevers` > .fname
	rm -rf `cat .fname`
	mkdir `cat .fname`
	SRCDIR=. ;\
	test $(srcdir) = "\@srcdir\@" && SRCDIR=$(srcdir) ;\
	for file in $(DISTFILES); do \
	  ln $$SRCDIR/$$file `cat .fname` \
	    || { echo copying $$file instead; cp -p $$file `cat .fname`; }; \
	done
	gtar -czf `cat .fname`.tar.gz `cat .fname`
	@echo Created `cat .fname`.tar.gz
	rm -rf `cat .fname` .fname

zipfile: $(DISTFILES) /tmp/vilevers
	vilevers=`cat /tmp/vilevers | sed 's/\.//'`; \
	zip -k vile$${vilevers}s.zip $(DISTFILES) ;\
	echo Created vile$${vilevers}s.zip

# DOS builds...
DOSBINARIES = README README.PC vile.hlp vile.exe

binzip_djg: $(DOSBINARIES) go32.exe /tmp/vilevers
	vilevers=`cat /tmp/vilevers | sed 's/\.//'`; \
	zip -k vile$${vilevers}b.zip $(DOSBINARIES) go32.exe ;\
	echo Created vile$${vilevers}b.zip

binzip_wat: $(DOSBINARIES) dos4gw.exe /tmp/vilevers
	vilevers=`cat /tmp/vilevers | sed 's/\.//'`; \
	zip -k vile$${vilevers}b.zip $(DOSBINARIES) dos4gw.exe ;\
	echo Created vile$${vilevers}b.zip

patch:	/tmp/vilevers
	@orevlistrev=`rlog -h revlist | egrep head: | cut -f2 -d'.'`	;\
	orevlistrev=1.`expr $$orevlistrev - 1`				;\
	ovilevers=`cat /tmp/vilevers | cut -f2 -d'.'`			;\
	ovilemajor=`cat /tmp/vilevers | cut -f1 -d'.'`			;\
	ovilevers=$$ovilemajor.`expr $$ovilevers - 1`			;\
	echo Previous version is $$ovilevers				;\
	vilevers=`cat /tmp/vilevers`					;\
	co -p$$orevlistrev revlist |					 \
	while read file filerev						;\
	do								 \
	  rcsdiff -c -u -r$$filerev $$file 2>/dev/null || true		;\
	done  >patch$$ovilevers-$$vilevers				;\
	echo Created patch$$ovilevers-$$vilevers

dpatch:
	co -p$(PATCH_AGAINST) revlist |					 \
	while read file filerev						;\
	do								 \
	  rcsdiff -c -u -r$$filerev $$file 2>/dev/null || true		;\
	done  >patchREL-CUR						;\
	echo Created patchREL-CUR

/tmp/vilevers: ALWAYS
	@expr "`egrep 'version\[\].*' edef.h`" : \
		'.* \([0-9][0-9]*\.[0-9].*\)".*' >/tmp/vilevers
	@echo Current version is `cat /tmp/vilevers`

release_warnings:
	@echo
	@echo 'Do you need to rebuild the revlist????  top comment is:'
	@rlog revlist | sed -n -e '/date/,/---------/p' | \
		sed -n '/date\|------------/!p' | sed -e 's/^/	/' -e 1q
	@echo 'or maybe date the CHANGES file?  it says:'
	@sed -n -e '/Changes/s/^/	/p' -e '2q' CHANGES
	@echo 'or maybe update the version info in patchlev.h?  it contains:'
	@fgrep '#define' patchlev.h | sed -e 's/^/	/'
	@echo 'how about the README?  it contains:'
	@sed -n -e '/version/s/^/	/p' -e '3q' README
	@echo 'or in vile.hlp?  it has:'
	@sed -n -e '/.*Getting along with vile	*/s//	/p' -e '5q' vile.hlp
	@echo 'or in vmsbuild.com?  it has:'
	@sed -n -e '/Identification=/s/^.*Vile \([^"]*\)["]*/	\1/p' vmsbuild.com
	@echo 'did you update/rename the RPM spec?'
	@ls -1 vile*.spec | sed -e 's/^/	/'
	@echo -n "Hit return to continue..."
	@read a

rcsdiffrw:
	@-for x in `$(MAKE) -f makefile.in rw`	;\
	do	\
		echo		;\
		echo $$x	;\
		echo =========	;\
		rcsdiff -u $$x	;\
	done 2>&1		;\
	echo			;\
	echo all done

# dump a list of the important files
list:
	@ls $(DEV_DISTFILES)

devonlylist:
	@ls $(DEVELOPER_ONLY)

# make a list of RCS revisions.  don't include the revlist itself
nrevlist:
	for f in `$(MAKE) -f makefile.in list  | egrep -v revlist`	;\
	do								\
		rev=`rlog -h $$f | egrep head: | cut -f2 -d' '`		;\
		echo "$$f	$$rev"					;\
	done >/tmp/vile_revlist
	mv /tmp/vile_revlist nrevlist

# dump a list of files that may have changed since last backup
rw:
	@ls -l $(DEV_DISTFILES) |\
		egrep '^[^l].w' | \
		sed 's;.* ;;'   # strip to last space

populate:
	for file in $(DEV_DISTFILES); do \
	test -f $$file || co $$file ;\
	done

perl.c: $(srcdir)/perl.xs $(srcdir)/ptypemap
	$(PERL) $(PERLLIB)/ExtUtils/xsubpp \
		-typemap $(PERLLIB)/ExtUtils/typemap \
		-typemap ptypemap \
		$(srcdir)/perl.xs > $@

$(OBJ): estruct.h proto.h edef.h $(BUILTHDRS) config.h

api$o :		api.h
bind$o :	btree.h
blist$o :	blist.h
btree$o :	btree.h
curses$o :	tcap.h xtermkeys.h
display$o :	pscreen.h
filec$o :	dirstuff.h
glob$o :	dirstuff.h
main$o :	chgdfunc.h
modes$o :	chgdfunc.h
path$o :	dirstuff.h
perl$o :	api.h
random$o :	dirstuff.h
statevar$o :	patchlev.h
tags$o :	btree.h
tcap$o :	tcap.h xtermkeys.h
version$o :	patchlev.h
x11$o :		pscreen.h

# test-drivers

test_btree$x:	btree.c
	$(CC) -o $@ -DDEBUG_BTREE $(CPPFLAGS) $(CFLAGS) btree.c $(LDFLAGS)

DEFS_REGEXP = -DDEBUG_REGEXP -DOPT_MULTIBYTE=0 $(CPPFLAGS)
TEST_REGEXP = regexp.c #trace$o

#DEFS_REGEXP = -DDEBUG_REGEXP -DTEST_MULTIBYTE_REGEX $(CPPFLAGS)
#TEST_REGEXP = regexp.c charsets$o eightbit$o wcwidth$o tbuff$o vl_ctype$o #trace$o

test_regexp$x:	$(TEST_REGEXP)
	$(CC) -o $@ $(DEFS_REGEXP) $(CFLAGS) $(TEST_REGEXP) $(LDFLAGS)

test_regexp.i:	$(TEST_REGEXP)
	$(CC) -C -E $(DEFS_REGEXP) $(CFLAGS) $(TEST_REGEXP) >$@

TEST_IO_OBJS	= \
	$(SCREEN)$o \
	nullterm$o \
	test_io$o

test_io$x :	$(TEST_IO_OBJS)
	$(CC) -o $@ $(TEST_IO_OBJS) $(CPPFLAGS) $(CFLAGS) $(LDFLAGS) $(LIBS)

# dependency-rules for install/installdirs
$(BINDIR)/xshell.sh:		$(srcdir)/xshell.sh
	$(INSTALL_SCRIPT)	$(srcdir)/xshell.sh $@
$(BINDIR)/lxvile-fonts:		$(srcdir)/macros/lxvile-fonts
	$(INSTALL_SCRIPT)	$(srcdir)/macros/lxvile-fonts $@
$(BINDIR)/lxvile:		$(srcdir)/macros/lxvile
	$(INSTALL_SCRIPT)	$(srcdir)/macros/lxvile $@
$(BINDIR)/uxvile:		$(srcdir)/macros/uxvile
	$(INSTALL_SCRIPT)	$(srcdir)/macros/uxvile $@
$(BINDIR)/vileget:		$(srcdir)/perl/vileget
	$(INSTALL_PL_EXE)	$(srcdir)/perl/vileget $@

$(DOCDIR)/Vileserv.doc:		$(srcdir)/doc/Vileserv.doc
	$(INSTALL_DATA)		$(srcdir)/doc/Vileserv.doc $@
$(DOCDIR)/config.doc:		$(srcdir)/doc/config.doc
	$(INSTALL_DATA)		$(srcdir)/doc/config.doc $@
$(DOCDIR)/dir.doc:		$(srcdir)/doc/dir.doc
	$(INSTALL_DATA)		$(srcdir)/doc/dir.doc $@
$(DOCDIR)/filters.doc:		$(srcdir)/doc/filters.doc
	$(INSTALL_DATA)		$(srcdir)/doc/filters.doc $@
$(DOCDIR)/macros.doc:		$(srcdir)/doc/macros.doc
	$(INSTALL_DATA)		$(srcdir)/doc/macros.doc $@
$(DOCDIR)/menus.doc:		$(srcdir)/doc/menus.doc
	$(INSTALL_DATA)		$(srcdir)/doc/menus.doc $@
$(DOCDIR)/modes.doc:		$(srcdir)/doc/modes.doc
	$(INSTALL_DATA)		$(srcdir)/doc/modes.doc $@
$(DOCDIR)/oleauto.doc:		$(srcdir)/doc/oleauto.doc
	$(INSTALL_DATA)		$(srcdir)/doc/oleauto.doc $@
$(DOCDIR)/perl.doc:		$(srcdir)/doc/perl.doc
	$(INSTALL_DATA)		$(srcdir)/doc/perl.doc $@
$(DOCDIR)/visvile.doc:		$(srcdir)/doc/visvile.doc
	$(INSTALL_DATA)		$(srcdir)/doc/visvile.doc $@

$(HTMLDIR)/vile-hlp.html:	$(srcdir)/doc/vile-hlp.html
	$(INSTALL_DATA)		$(srcdir)/doc/vile-hlp.html $@
$(HTMLDIR)/vile-toc.html:	$(srcdir)/doc/vile-toc.html
	$(INSTALL_DATA)		$(srcdir)/doc/vile-toc.html $@
$(HTMLDIR)/Vileserv.html:	$(srcdir)/doc/Vileserv.html
	$(INSTALL_DATA)		$(srcdir)/doc/Vileserv.html $@
$(HTMLDIR)/config.html:		$(srcdir)/doc/config.html
	$(INSTALL_DATA)		$(srcdir)/doc/config.html $@
$(HTMLDIR)/dir.html:		$(srcdir)/doc/dir.html
	$(INSTALL_DATA)		$(srcdir)/doc/dir.html $@
$(HTMLDIR)/filters.html:	$(srcdir)/doc/filters.html
	$(INSTALL_DATA)		$(srcdir)/doc/filters.html $@
$(HTMLDIR)/macros.html:		$(srcdir)/doc/macros.html
	$(INSTALL_DATA)		$(srcdir)/doc/macros.html $@
$(HTMLDIR)/menus.html:		$(srcdir)/doc/menus.html
	$(INSTALL_DATA)		$(srcdir)/doc/menus.html $@
$(HTMLDIR)/modes.html:		$(srcdir)/doc/modes.html
	$(INSTALL_DATA)		$(srcdir)/doc/modes.html $@
$(HTMLDIR)/oleauto.html:	$(srcdir)/doc/oleauto.html
	$(INSTALL_DATA)		$(srcdir)/doc/oleauto.html $@
$(HTMLDIR)/perl.html:		$(srcdir)/doc/perl.html
	$(INSTALL_DATA)		$(srcdir)/doc/perl.html $@
$(HTMLDIR)/visvile.html:	$(srcdir)/doc/visvile.html
	$(INSTALL_DATA)		$(srcdir)/doc/visvile.html $@

$(DATADIR)/color-ls.rc:		$(srcdir)/macros/color-ls.rc
	$(INSTALL_DATA)		$(srcdir)/macros/color-ls.rc $@
$(DATADIR)/dates.rc:		$(srcdir)/macros/dates.rc
	$(INSTALL_DATA)		$(srcdir)/macros/dates.rc $@
$(DATADIR)/digraphs.rc:		$(srcdir)/macros/digraphs.rc
	$(INSTALL_DATA)		$(srcdir)/macros/digraphs.rc $@
$(DATADIR)/gnugpg.rc:		$(srcdir)/macros/gnugpg.rc
	$(INSTALL_DATA)		$(srcdir)/macros/gnugpg.rc $@
$(DATADIR)/loaderrs.rc:		$(srcdir)/macros/loaderrs.rc
	$(INSTALL_DATA)		$(srcdir)/macros/loaderrs.rc $@
$(DATADIR)/manpage.rc:		$(srcdir)/macros/manpage.rc
	$(INSTALL_DATA)		$(srcdir)/macros/manpage.rc $@
$(DATADIR)/modes.rc:		$(srcdir)/macros/modes.rc
	$(INSTALL_DATA)		$(srcdir)/macros/modes.rc $@
$(DATADIR)/palettes.rc:		$(srcdir)/macros/palettes.rc
	$(INSTALL_DATA)		$(srcdir)/macros/palettes.rc $@
$(DATADIR)/pictmode.rc:		$(srcdir)/macros/pictmode.rc
	$(INSTALL_DATA)		$(srcdir)/macros/pictmode.rc $@
$(DATADIR)/search.rc:		$(srcdir)/macros/search.rc
	$(INSTALL_DATA)		$(srcdir)/macros/search.rc $@
$(DATADIR)/shifts.rc:		$(srcdir)/macros/shifts.rc
	$(INSTALL_DATA)		$(srcdir)/macros/shifts.rc $@
$(DATADIR)/showeach.rc:		$(srcdir)/macros/showeach.rc
	$(INSTALL_DATA)		$(srcdir)/macros/showeach.rc $@
$(DATADIR)/vileinit.rc:		$(srcdir)/macros/vileinit.rc
	$(INSTALL_DATA)		$(srcdir)/macros/vileinit.rc $@
$(DATADIR)/vileperl.rc:		$(srcdir)/macros/vileperl.rc
	$(INSTALL_DATA)		$(srcdir)/macros/vileperl.rc $@
$(DATADIR)/which.rc:		$(srcdir)/macros/which.rc
	$(INSTALL_DATA)		$(srcdir)/macros/which.rc $@

$(DATADIR)/vilemenu.rc:		$(srcdir)/macros/vilemenu.rc
	$(INSTALL_DATA)		$(srcdir)/macros/vilemenu.rc $@

$(DATADIR)/vile.hlp:		$(srcdir)/vile.hlp
	$(INSTALL_DATA)		$(srcdir)/vile.hlp $@

$(PERLDIR)/Breadcrumbs.pm:	$(srcdir)/perl/Breadcrumbs.pm
	$(INSTALL_DATA)		$(srcdir)/perl/Breadcrumbs.pm $@
$(PERLDIR)/CaptHook.pm:		$(srcdir)/perl/CaptHook.pm
	$(INSTALL_DATA)		$(srcdir)/perl/CaptHook.pm $@
$(PERLDIR)/Glob2re.pm:		$(srcdir)/perl/Glob2re.pm
	$(INSTALL_DATA)		$(srcdir)/perl/Glob2re.pm $@
$(PERLDIR)/Help.pm:		$(srcdir)/perl/Help.pm
	$(INSTALL_DATA)		$(srcdir)/perl/Help.pm $@
$(PERLDIR)/Vile.pm:		$(srcdir)/perl/Vile.pm
	$(INSTALL_DATA)		$(srcdir)/perl/Vile.pm $@
$(PERLDIR)/Vile/Exporter.pm:	$(srcdir)/perl/Vile/Exporter.pm
	$(INSTALL_DATA)		$(srcdir)/perl/Vile/Exporter.pm $@
$(PERLDIR)/Vile/Manual.pm:	$(srcdir)/perl/Vile/Manual.pm
	$(INSTALL_DATA)		$(srcdir)/perl/Vile/Manual.pm $@
$(PERLDIR)/Vileserv.pm:		$(srcdir)/perl/Vileserv.pm
	$(INSTALL_MODULE)	$(srcdir)/perl/Vileserv.pm $@
$(PERLDIR)/Visit.pm:		$(srcdir)/perl/Visit.pm
	$(INSTALL_DATA)		$(srcdir)/perl/Visit.pm $@
$(PERLDIR)/capture.pm:		$(srcdir)/perl/capture.pm
	$(INSTALL_DATA)		$(srcdir)/perl/capture.pm $@
$(PERLDIR)/dict.pm:		$(srcdir)/perl/dict.pm
	$(INSTALL_DATA)		$(srcdir)/perl/dict.pm $@
$(PERLDIR)/directory.pm:	$(srcdir)/perl/directory.pm
	$(INSTALL_DATA)		$(srcdir)/perl/directory.pm $@
$(PERLDIR)/dirlist.pm:		$(srcdir)/perl/dirlist.pm
	$(INSTALL_DATA)		$(srcdir)/perl/dirlist.pm $@
$(PERLDIR)/gdb.pm:		$(srcdir)/perl/gdb.pm
	$(INSTALL_DATA)		$(srcdir)/perl/gdb.pm $@
$(PERLDIR)/hgrep.pm:		$(srcdir)/perl/hgrep.pm
	$(INSTALL_DATA)		$(srcdir)/perl/hgrep.pm $@
$(PERLDIR)/lock.pm:		$(srcdir)/perl/lock.pm
	$(INSTALL_DATA)		$(srcdir)/perl/lock.pm $@
$(PERLDIR)/man.pm:		$(srcdir)/perl/man.pm
	$(INSTALL_DATA)		$(srcdir)/perl/man.pm $@
$(PERLDIR)/mime.pl:		$(srcdir)/perl/mime.pl
	$(INSTALL_DATA)		$(srcdir)/perl/mime.pl $@
$(PERLDIR)/plugins.pl:		$(srcdir)/perl/plugins.pl
	$(INSTALL_DATA)		$(srcdir)/perl/plugins.pl $@
$(PERLDIR)/search.pm:		$(srcdir)/perl/search.pm
	$(INSTALL_DATA)		$(srcdir)/perl/search.pm $@
$(PERLDIR)/shell.pm:		$(srcdir)/perl/shell.pm
	$(INSTALL_DATA)		$(srcdir)/perl/shell.pm $@
$(PERLDIR)/spell.pm:		$(srcdir)/perl/spell.pm
	$(INSTALL_DATA)		$(srcdir)/perl/spell.pm $@
$(PERLDIR)/winops.pm:		$(srcdir)/perl/winops.pm
	$(INSTALL_DATA)		$(srcdir)/perl/winops.pm $@

$(INSTALL_DIRS):
	mkdir -p $@

ALWAYS:

depend : $(BUILTHDRS) $(OBJ)
	makedepend $(CPPFLAGS) -- $(CFLAGS) -- `echo $(OBJ) | sed -e 's/\.o/.c/g'`

# DO NOT DELETE THIS LINE -- make depend depends on it.