package Dist::Milla::App;
use strict;
use parent 'Dist::Zilla::App';
use version; our $VERSION = version->declare('v1.0.12');

sub _default_command_base { 'Dist::Zilla::App::Command' }

sub prepare_command {
    my $self = shift;

    my($cmd, $opt, @args) = $self->SUPER::prepare_command(@_);

    if ($cmd->isa("Dist::Zilla::App::Command::install")) {
        $opt->{install_command} ||= 'cpanm .';
    } elsif ($cmd->isa("Dist::Zilla::App::Command::release")) {
        $ENV{DZIL_CONFIRMRELEASE_DEFAULT} = 1
          unless defined $ENV{DZIL_CONFIRMRELEASE_DEFAULT};
    } elsif ($cmd->isa("Dist::Zilla::App::Command::new")) {
        $opt->{provider} = 'Milla';
    }

    return $cmd, $opt, @args;
}

1;
