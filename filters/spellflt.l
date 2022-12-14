%pointer

%{

/*
 * $Header: /usr/build/vile/vile/filters/RCS/spellflt.l,v 1.49 2010/07/13 13:47:24 tom Exp $
 *
 * Filter to add vile "attribution" sequences to misspelled words.
 */

#ifdef filter_def
#include <estruct.h>
#include <edef.h>
#endif

#include <filters.h>

DefineFilter("spell");

#define BUFFER_SIZE	BUFSIZ

/* console applications for win32 have popen, GUI applications do not */
#if defined(_WIN32) && !defined(popen)
#define popen _popen
#define pclose fclose
#endif

#ifndef SPELL_PROG
#define SPELL_PROG "spell"
#endif

/* -l	Produce a list of misspelled words */
/* -x	Don't create a backup file (ispell, aspell). */
#ifndef SPELL_OPTS
#define SPELL_OPTS "-l"
#endif

#define SPELL_PIPE SPELL_PROG " " SPELL_OPTS

static FILE *ChopFP;
static void ChopWords(FILE *fp, char *text, int len);

#ifdef HAVE_POPEN
#define pipe_open(command)	popen(command, "r")
#define	pipe_read(b,s)		fgets(b, sizeof(b), s)
#define pipe_close(s)		pclose(s)
#else				/* platforms with no workable popen */
#ifdef filter_def		/* built-in filter? */
#define HAVE_POPEN		/* we can fake it */
static char lastdata[BUFFER_SIZE];
static B_COUNT lastsize;

static FILE *
pipe_open(const char *command)
{
    FILE *result = 0;
    char buffer[BUFFER_SIZE + 2];

    sprintf(buffer, "!%s", command);
    if (ffropen(buffer) == FIOSUC)
	result = ffp;

    lastsize = 0;
    return result;
}

static char *
pipe_read(char *buffer, FILE *s)
{
    char *result = buffer;
    B_COUNT len;
    int done = 0;

    (void) s;
    do {
	if (lastsize != 0) {
	    B_COUNT used = 0;
	    for (len = 0; len < lastsize; ++len) {
		if (done) {
		    lastdata[len - used] = lastdata[len];
		} else {
		    if ((buffer + 1 - result) >= BUFFER_SIZE
			|| (*buffer++ = lastdata[len]) == '\n') {
			done = 1;
		    }
		    used = len + 1;
		}
	    }
	    if (done) {
		lastsize -= used;
	    } else {
		lastsize = 0;
	    }
	}

	if (!done) {
	    if (ffread(lastdata, sizeof(lastdata), &lastsize) < 0) {
		done = 1;
	    }
	}
    } while (!done);

    *buffer = 0;
    if (buffer == result)
	result = 0;

    return result;
}

static void
pipe_close(FILE *s)
{
    (void) s;
    ffclose();
}
#endif				/* filter_def */
#endif				/* HAVE_POPEN */

static FILE *
open_tempfile(char **fname)
{
    FILE *fp = 0;
#ifdef HAVE_MKSTEMP
    const char fmt[] = "%s/vileXXXXXX";
    const char *tmpdir = getenv("TMPDIR");
    int fd;

    if (tmpdir == NULL)
        tmpdir = "/tmp";
    if ((*fname = (char *) malloc(strlen(tmpdir) + sizeof(fmt))) != 0) {
	sprintf(*fname, fmt, tmpdir);
	fd = mkstemp(*fname);
	if (fd >= 0)
	    fp = fdopen(fd, "w");
    }
#else
    int oldmask = umask(0077);
    char *result = tmpnam((char *)0);
    if (result != 0 && (*fname = malloc(2 * strlen(result) + 1)) != 0) {
	strcpy(*fname, result);
	fp = fopen(*fname, "w");
    }
    umask(oldmask);
#endif
    return fp;
}

static void
zap_tempfile(char **fname)
{
    remove(*fname);
    free(*fname);
    *fname = 0;
}

%}

WORD		[[:alpha:]]([[:alnum:]])*

%%

{WORD}		{ ChopWords(ChopFP, yytext, yyleng); }
[\n\r]		|
.		{ if (ChopFP == 0) flt_putc(*yytext); }

%%

static void
ChopWords(FILE *fp, char *text, int len)
{
    char *base = text;
    const char *attr;
    int next = len;
    char save;

    /*
     * Write the whole "word", just in case the chopped flavor is not needed.
     */
    if (fp != 0) {
	IGNORE_RC(fwrite(text, sizeof(*text), (size_t) len, fp));
	fputc('\n', fp);
    } else {
	attr = keyword_attr(text);
	if (isEmpty(attr)) {
	    flt_puts(text, next, attr);
	    return;
	}
    }

    while (len > 0) {
	int c1;
	int c2;
	int all_upper = 0;
	int all_lower = 0;
	int n;

	/*
	 * Handle three cases:  all lowercase, all uppercase, or one leading
	 * cap.  Don't check spelling of a single letter.
	 */
	next = len;
	for (n = 0; n < len; ++n) {
	    c1 = CharOf(text[n]);
	    if (isalpha(c1)) {
		if (isupper(c1)) {
		    if (all_lower) {
			next = n;
			break;
		    } else if (all_upper) {
			c2 = ((n + 1) < len) ? CharOf(text[n + 1]) : 0;
			if (islower(c2)) {
			    next = n;
			    break;
			}
		    }
		    ++all_upper;
		} else {
		    if (all_upper) {
			if (n == 1) {
			    all_lower = 0;
			    all_upper = 0;
			} else {
			    next = n;
			    break;
			}
		    }
		    ++all_lower;
		}
	    }
	}

	if (fp != 0) {
	    if (text != base || next != len) {
		IGNORE_RC(fwrite(text, sizeof(*text), (size_t) next, fp));
		IGNORE_RC(fputc('\n', fp));
	    }
	} else {
	    if (next > 1) {
		save = text[next];
		text[next] = '\0';
		attr = keyword_attr(text);
		if (attr != 0)
		    flt_error("%s", text);
		text[next] = save;
	    } else {
		attr = "";
	    }
	    flt_puts(text, next, attr);
	}
	text += next;
	len -= next;
    }
}

static void
init_filter(int before GCC_UNUSED)
{
    (void) before;
}

static void
do_filter(FILE *inputs GCC_UNUSED)
{
#ifdef HAVE_POPEN
#ifdef filter_def
    LINE *lp;
#else
    FILE *FromFP;
    char *from;
    int ch;
#endif
    char *chop;
    FILE *fp;
    char buffer[BUFFER_SIZE + 2];
    const char *attr = class_attr(NAME_ERROR);
    const char *prog;

    (void) inputs;

    /*
     * Create a temporary file which will hold the words to check spelling.
     */
    if ((ChopFP = open_tempfile(&chop)) == 0)
	return;

#ifdef filter_def		/* built-in filter? */
    ffp = ChopFP;
    for_each_line(lp, curbp) {
	ffputline(lp->l_text, llength(lp), "\n");
    }
    RunLEX();
#else				/* external filter */
    if ((FromFP = open_tempfile(&from)) == 0) {
	fclose(ChopFP);
	zap_tempfile(&from);
	zap_tempfile(&chop);
	return;
    }
    while ((ch = fgetc(inputs)) != EOF)
	fputc(ch, FromFP);
    fclose(FromFP);

    yyin = fopen(from, "r");
    RunLEX();
    fclose(yyin);

    yyin = fopen(from, "r");
#endif

    fclose(ChopFP);
    ChopFP = 0;

#ifdef filter_def		/* built-in filter? */
    ffstatus = file_is_closed;
    ffp = 0;
#endif

    /*
     * Run the spelling checker, reading the misspelled words from the pipe.
     * Record those in the keyword table.
     */
    if ((prog = vile_getenv("VILE_SPELL_FILT")) == 0)
	prog = SPELL_PIPE;
    sprintf(buffer, "%s <%s", prog, chop);
    if ((fp = pipe_open(buffer)) != 0) {
	while (pipe_read(buffer, fp)) {
	    size_t len  = strlen(buffer);
	    while (len-- && isspace(CharOf(buffer[len]))) {
		buffer[len] = 0;
	    }
	    if (*buffer) {
		/*
		 * If user did not override with an entry in spell.keywords,
		 * add the latest as a misspelled word to highlight.
		 */
		if (keyword_attr(buffer) == 0) {
		    insert_keyword(buffer, attr, 0);
		}
	    }
	}
	pipe_close(fp);
    }
    zap_tempfile(&chop);

    /*
     * Reparse the buffer, marking the misspelled words.
     */
#ifdef filter_def		/* built-in filter? */
    flt_restart(default_table);
#endif
    BEGIN(INITIAL);
    RunLEX();

#ifndef filter_def		/* external filter? */
    fclose(yyin);		/* yylex() may not close */
    zap_tempfile(&from);
#endif

#endif /* HAVE_POPEN */
}

#if NO_LEAKS
static void
free_filter(void)
{
    USE_LEXFREE;
}
#endif
