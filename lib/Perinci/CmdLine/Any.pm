package Perinci::CmdLine::Any;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

my %Opts = (
    -prefer_lite => 0,
);

sub import {
    my ($class, %args) = @_;
    $Opts{$_} = $args{$_} for keys %args;
}

sub new {
    my $class = shift;

    my $pericmd_ver = 1.04;

    my @mods;
    my $env = $ENV{PERINCI_CMDLINE_ANY};
    if ($env) {
        if ($env eq 'classic') {
            $env = 'Perinci::CmdLine';
        } elsif ($env eq 'lite') {
            $env = 'Perinci::CmdLine::Lite';
        }
        @mods = ($env);
    } elsif ($Opts{-prefer_lite}) {
        @mods = qw(Perinci::CmdLine::Lite Perinci::CmdLine);
    } else {
        @mods = qw(Perinci::CmdLine Perinci::CmdLine::Lite);
    }

    for my $i (1..@mods) {
        my $mod = $mods[$i-1];
        my $modpm = $mod; $modpm =~ s!::!/!g; $modpm .= ".pm";
        if ($i == @mods) {
            require $modpm;
            if ($mod eq 'Perinci::CmdLine') {
                Perinci::CmdLine->VERSION($pericmd_ver);
            }
            return $mod->new(@_);
        } else {
            my $res;
            eval {
                require $modpm;
                if ($mod eq 'Perinci::CmdLine') {
                    Perinci::CmdLine->VERSION($pericmd_ver);
                }
                $res = $mod->new(@_);
            };
            if ($@) {
                next;
            } else {
                return $res;
            }
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
L<Perinci::CmdLine::Lite> as the fallback. The goal is to reduce dependencies.
Perinci::CmdLine::Any only depends on the lightweight Perinci::CmdLine::Lite,
which has +- 20 non-core Perl modules as dependency, while installing
Perinci::CmdLine will pull +-200 non-core modules.

Note that Perinci::CmdLine::Lite provides only a subset of the
functionalities/features of Perinci::CmdLine.

If you want to force using a specific class, you can set the
C<PERINCI_CMDLINE_ANY> environment variable, e.g. the command below will choose
Perinci::CmdLine::Lite even though Perinci::CmdLine is available:

 % PERINCI_CMDLINE_ANY=Perinci::CmdLine::Lite yourapp.pl

If you want to prefer to Perinci::CmdLine::Lite (but user will still be able to
override using C<PERINCI_CMDLINE_ANY>):

 use Perinci::CmdLine::Any -prefer_lite => 1;


=head1 ENVIRONMENT

=head2 PERINCI_CMDLINE_ANY => str

Either specify module name, or C<lite> or C<classic>.


=head1 SEE ALSO

L<Perinci::CmdLine>

L<Perinci::CmdLine::Lite>

=cut
