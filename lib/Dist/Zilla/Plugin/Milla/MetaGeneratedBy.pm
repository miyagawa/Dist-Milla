package Dist::Zilla::Plugin::Milla::MetaGeneratedBy;
use Moose;
with 'Dist::Zilla::Role::MetaProvider';

use Dist::Milla;

sub metadata {
    my $self = shift;

    return {
        generated_by => "Dist::Milla version "
          . (defined Dist::Milla->VERSION ? Dist::Milla->VERSION : '(undef)'),
    };
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
