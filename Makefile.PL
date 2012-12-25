use 5.010001;
use inc::Module::Install::DSL 1.06;

all_from lib/Bullwinkle/Client.pm
all_from lib/Bullwinkle/Server.pm

requires_from lib/Bullwinkle/Client.pm
requires_from lib/Bullwinkle/Server.pm

requires Carp                1.26
requires Carp::Always::Color 0.06
requires Data::Dumper        2.139
requires Data::Printer       0.35
requires IO::Socket::IP      0.18
requires JSON::Types         0.05
requires JSON::XS            2.33
requires Moo                 1.000007
requires Thread::Semaphore   2.12
requires Try::Tiny           0.11
requires Wx                  0.9914

test_requires Test::Deep       0.110
test_requires Test::More       0.98
test_requires Test::SharedFork 0.21

homepage    https://github.com/kevindawson/Bullwinkle
bugtracker  https://github.com/kevindawson/Bullwinkle/issues
repository  git://github.com/kevindawson/Bullwinkle.git

no_index directory  qw{ t xt eg share inc privinc }

