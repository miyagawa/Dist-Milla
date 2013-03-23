package Dist::Zilla::Plugin::NameFromDirectory;
use Moose;
with 'Dist::Zilla::Role::NameProvider';

use Cwd;
use Path::Class;

sub provide_name {
    my $self = shift;

    my $root = dir(Cwd::cwd);

    # make sure it is a root dir, by checking -e dist.ini
    return unless -e $root->file('dist.ini');

    my $name = $root->basename;
    $name =~ s/(?:^(?:perl|p5)-|[\-\.]pm$)//x;
    $self->log("guessing your distribution name is $name");

    return $name;
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
