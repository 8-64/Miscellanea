#!/usr/local/bin/python3

import os
import sys

print('Why hello from ' + sys.executable + ' (PID ' + str(os.getpid()) + ')')

os.execvp('perl', ['perl', '-x', __file__])

"""
#!/usr/bin/perl

use v5.24;

say "Hello from $^X (PID $$)";

__END__
"""
