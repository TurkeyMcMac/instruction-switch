#include <stdio.h>
#include <arpa/inet.h>

int codepoint(const char *ch)
{
	unsigned instr = ntohl(*(unsigned *)ch);
#define INSTR_ instr
#define DO_INSTR_(name, n_args, bits) return bits;
#define DO_ERROR_ return -1;
#include "utf8.switch"
#undef INSTR_
#undef DO_INSTR_
#undef DO_ERROR_
}

int main(int argc, char *argv[])
{
	const char *ch = "☺";
	int cp;
	if (argc > 1) {
		ch = argv[1];
	}
	cp = codepoint(ch);
	if (cp < 0) {
		printf("Invalid character.\n");
	} else {
		printf("'%s' => %X\n", ch, cp);
	}
}
