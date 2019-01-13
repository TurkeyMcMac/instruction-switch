BEGIN {
	pwd = ENVIRON["PWD"];
	print("#!/usr/bin/env ruby");
}

/^load ".+"$/ {
	basename = substr($0, 7, length($0) - 7);
	printf("load '%s/src/%s'\n", pwd, basename);
	next;
}

{print;}
