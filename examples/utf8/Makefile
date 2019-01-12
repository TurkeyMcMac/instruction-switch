executable = codepoint
program = codepoint.c
table = utf8.tsv
switch = utf8.switch

$(executable): $(program) $(switch)
	$(CC) -o $(executable) $(program)

$(switch): $(table)
	../../instrswitch $(table) > $(switch)
