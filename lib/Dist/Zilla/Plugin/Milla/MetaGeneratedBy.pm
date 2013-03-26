package Dist::Zilla::Plugin::Milla::MetaGeneratedBy;
use Moose;
with 'Dist::Zilla::Role::MetaProvider';

use Dist::Milla;

sub metadata {
    my $self = shift;

    my $generated_by = sprintf "Dist::Milla version %s, Dist::Zilla version %s",
      Dist::Milla->VERSION, $self->zilla->VERSION;

    return {
        generated_by => $generated_by,
    };
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
