package Dist::Zilla::Plugin::DistINI::Milla;
use Moose;
with qw(Dist::Zilla::Role::FileGatherer);

sub gather_files {
    my($self, $arg) = @_;

    my $file = Dist::Zilla::File::InMemory->new({
        name    => 'dist.ini',
        content => "[\@Milla]\n",
    });

    $self->add_file($file);
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
