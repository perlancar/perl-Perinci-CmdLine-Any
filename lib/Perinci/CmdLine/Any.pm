package Perinci::CmdLine::Any;

use 5.010001;
use strict;
use warnings;

# DATE
# VERSION

our @ISA;

eval { require Perinci::CmdLine; Perinci::CmdLine->VERSION(1.17) };
if ($@) {
    require Perinci::CmdLine::Lite;
    @ISA = qw(Perinci::CmdLine::Lite);
} else {
    @ISA = qw(Perinci::CmdLine);
}

1;
# ABSTRACT: Use Perinci::CmdLine, fallback on Perinci::CmdLine::Lite

=head1 SYNOPSIS

 In your command-line script:

 #!perl
 use Perinci::CmdLine::Any;
 Perinci::CmdLine::Any->new(url => '/Package/func')->run;


=head1 DESCRIPTION

This module lets you use L<Perinci::CmdLine> if it's available, or
L<Perinci::CmdLine::Lite> as the fallback. The goal is to reduce dependencies
(Perinci::CmdLine::Any only depends on the lightweight Perinci::CmdLine::Lite)
but use the richer Perinci::CmdLine if it's available.

Note that Perinci::CmdLine::Lite provides only a subset of the
functionalities/features of Perinci::CmdLine.


=head1 SEE ALSO

L<Perinci::CmdLine>

L<Perinci::CmdLine::Lite>

=cut
