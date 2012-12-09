#!/usr/bin/perl

use strict;
use warnings;

BEGIN {
    print "hi\n";
}

print "there!\n";

1;

__END__

I did look at it the other day. It is already a little too detailed in advance 
of what's there and what's needed now. For example, this notion of whether the 
program has started or not, doesn't exist in Perl. It exists in gdb, but that's 
a very different environment.

By the time you've entered any Perl debugger there already has been some code 
that has been executed. Possibly in use statements, possibly in a  BEGIN or Perl 
modules that have been loaded via the -M option. Run this code with your debugger:

BEGIN {
    print "hi\n";
}

print "there!\n";

And see where you stop. It is possible to arrange to call the debugger inside 
the BEGIN and more generally make dynamic calls to a debugger. 
One could conceivably have some sort of indicator that this is the first time 
the debugger has been entered. But again it might not have any relation to where 
you are in the program.

So in return I suggest looking at "info program" in Devel::Trepan which will 
give you information about what status information is already there. The whole 
file implementing the command is only 67 lines long but the relevant subroutine 
"run" is about 30 lines long. (If nothing else, the fact there is such a command 
that encapsulates this information puts it in my opinion DT a little bit ahead of 
perl5db.pl for such things like this. And the genius is not so much in my inventing 
such a thing but just following gdb.)

Of course that command produces text output and that's not what is desired here. 
But I think to be pedagogical, I'll just port that information over directly to give a feel.

It's fine to change information around, add or delete information. 
But it is too early right now to design much. I'd like to see changes dictated more by need.

Which brings me more to the main thing about debugger requests. 
It would be very helpful to have the name of the request in the request. 
The top-level breakout is to look at the request name and dispatch the request on that. 
In a command-line debugger, the first word token is the debugger command name 
like "info" or "step" and that is generally what is used to dispatch the command.

(The ruby debugger ruby-debug did this in a slightly different and interesting 
way that is also somewhat common: match the entire input against a regular 
expression. So here you don't strictly have to key on the first word although in 
practice that's what is done. However regular expressions matching an the 
entire command becomes quickly too cumbersome and in some cases what you 
really want is something on the order of a LPEG grammar.)