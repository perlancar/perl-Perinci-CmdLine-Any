package Perinci::CmdLine::Any;

use strict;
# IFUNBUILT
use warnings;
# END IFUNBUILT

# AUTHORITY
# DATE
# DIST
# VERSION

my %Opts = (
    -prefer_lite => 1,
);

sub import {
    my ($class, %args) = @_;
    $Opts{$_} = $args{$_} for keys %args;
}

sub new {
    my $class = shift;

    my @mods;
    my $env = $ENV{PERINCI_CMDLINE_ANY};
    if ($env) {
        if ($env eq 'classic') {
            $env = 'Perinci::CmdLine::Classic';
        } elsif ($env eq 'lite') {
            $env = 'Perinci::CmdLine::Lite';
        }
        @mods = ($env);
    } elsif ($Opts{-prefer_lite}) {
        @mods = qw(Perinci::CmdLine::Lite Perinci::CmdLine::Classic);
    } else {
        @mods = qw(Perinci::CmdLine::Classic Perinci::CmdLine::Lite);
    }

    for my $i (1..@mods) {
        my $mod = $mods[$i-1];
        my $modpm = $mod; $modpm =~ s!::!/!g; $modpm .= ".pm";
        if ($i == @mods) {
            require $modpm;
            return $mod->new(@_);
        } else {
            my $res;
            eval {
                require $modpm;
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
# ABSTRACT: Choose Perinci::CmdLine implementation (::Lite or ::Classic)

=for Pod::Coverage ^(new)$

=head1 SYNOPSIS

In your command-line script (this will pick ::Lite first):

 #!perl
 use Perinci::CmdLine::Any;
 Perinci::CmdLine::Any->new(url => '/Package/func')->run;

In your command-line script (this will pick ::Classic first, and falls back to
::Lite):

 #!perl
 use Perinci::CmdLine::Any -prefer_lite=>0;
 Perinci::CmdLine::Any->new(url => '/Package/func')->run;


=head1 DESCRIPTION

This module lets you use L<Perinci::CmdLine::Lite> or
L<Perinci::CmdLine::Classic>.

If you want to force using a specific class, you can set the
C<PERINCI_CMDLINE_ANY> environment variable, e.g. the command below will only
try to use Perinci::CmdLine::Classic:

 % PERINCI_CMDLINE_ANY=Perinci::CmdLine::Classic yourapp.pl
 % PERINCI_CMDLINE_ANY=classic yourapp.pl

If you want to prefer to Perinci::CmdLine::Classic (but user will still be able
to override using C<PERINCI_CMDLINE_ANY>):

 use Perinci::CmdLine::Any -prefer_lite => 0;


=head1 ENVIRONMENT

=head2 PERINCI_CMDLINE_ANY => str

Either specify module name, or C<lite> or C<classic>.


=head1 SEE ALSO

L<Perinci::CmdLine::Lite>, L<Perinci::CmdLine::Classic>

Another alternative backend, but not available through Perinci::CmdLine::Any
since it works by generating script instead: L<Perinci::CmdLine::Inline>

=cut
