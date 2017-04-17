package Dist::Milla::App;
use strict;
use parent 'Dist::Zilla::App';
use version; our $VERSION = version->declare('v1.0.17');

sub _default_command_base { 'Dist::Zilla::App::Command' }

sub prepare_command {
    my $self = shift;

    my($cmd, $opt, @args) = $self->SUPER::prepare_command(
        $self->_check_default_profile_provider(@_)
    );

    if ($cmd->isa("Dist::Zilla::App::Command::install")) {
        $opt->{install_command} ||= 'cpanm .';
    } elsif ($cmd->isa("Dist::Zilla::App::Command::release")) {
        $ENV{DZIL_CONFIRMRELEASE_DEFAULT} = 1
          unless defined $ENV{DZIL_CONFIRMRELEASE_DEFAULT};
    } 

    return $cmd, $opt, @args;
}

sub _check_default_profile_provider {
    my ($self, @opts) = @_;
 
    if ($opts[0] eq 'new' && !grep(/^\-P|\-\-provider$/, @opts)) {
        splice(@opts, 1, 0, '-P', 'Milla');
    }
    
    return @opts;
}

1;
