package Perinci::CmdLine::Any;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

sub new {
    my $class = shift;

    my $pericmd_ver = 1.17;

    if ($ENV{PERINCI_CMDLINE_ANY}) {
        my $mod = $ENV{PERINCI_CMDLINE_ANY};
        my $modpm = $mod; $modpm =~ s!::!/!g; $modpm .= ".pm";
        require $modpm;
        if ($mod eq 'Perinci::CmdLine') {
            Perinci::CmdLine->VERSION($pericmd_ver);
        }
        $mod->new(@_);
    } else {
        eval {
            require Perinci::CmdLine;
            Perinci::CmdLine->VERSION($pericmd_ver);
        };
        if ($@) {
            require Perinci::CmdLine::Lite;
            Perinci::CmdLine::Lite->new(@_);
        } else {
            Perinci::CmdLine->new(@_);
        }
    }
}

1;
# ABSTRACT: Use Perinci::CmdLine, fallback on Perinci::CmdLine::Lite

=for Pod::Coverage ^(new)$

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

If you want to force using a specific class, you can set the
C<PERINCI_CMDLINE_ANY> environment variable, e.g. the command below will choose
Perinci::CmdLine::Lite even though Perinci::CmdLine is available:

 % PERINCI_CMDLINE_ANY=Perinci::CmdLine::Lite yourapp.pl


=head1 ENVIRONMENT

=head2 PERINCI_CMDLINE_ANY => str


=head1 SEE ALSO

L<Perinci::CmdLine>

L<Perinci::CmdLine::Lite>

=cut
