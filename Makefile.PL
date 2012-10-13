use 5.010001;
use inc::Module::Install::DSL 1.06;

all_from lib/Bullwinkle/Client.pm
all_from lib/Bullwinkle/Server.pm

requires_from lib/Bullwinkle/Client.pm
requires_from lib/Bullwinkle/Server.pm

requires Moo                  1.000003
requires Wx                   0.99
requires File::Which          1.09
requires Try::Tiny            0.11
requires Carp::Always::Color  0.06
requires IO::Socket::IP       0.17
requires IPC::System::Simple  1.21
requires Carp                 1.20
requires Try::Tiny            0.11
requires JSON::XS             2.33
requires Data::Dumper         2.131
requires Data::Printer        0.33


test_requires Test::More           0.98
test_requires Test::Fork           0.02
test_requires Test::Pod            1.14
test_requires Test::Pod::Coverage  1.08
test_requires Perl::Critic         1.098
test_requires Test::Perl::Critic   1.01


homepage    https://github.com/kevindawson/Bullwinkle
bugtracker  https://github.com/kevindawson/Bullwinkle/issues
repository  git://github.com/kevindawson/Bullwinkle.git

no_index directory  qw{ t xt eg share inc privinc }
