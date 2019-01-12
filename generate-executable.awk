BEGIN {
	print "#!/usr/bin/env ruby";
	print "# This file is an automatically generated concatenation of";
	print "# several source files whose names are indicated by comments";
	print "# starting with 'LOADED FILE'.";
	print;
}

/^load ".+"$/ {
	path = substr($0, 7, length($0) - 7);
	print("# LOADED FILE: " path);
	system("cat " path);
	next;
}

{print;}
