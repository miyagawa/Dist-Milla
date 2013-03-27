package Dist::Zilla::Plugin::Milla::FirstBuild;
use Moose;
with 'Dist::Zilla::Role::AfterMint';

use Dist::Milla::App;
use File::pushd;
use Git::Wrapper;

sub after_mint {
    my($self, $opts) = @_;

    $self->log("Running the initial build & clean");

    {
        my $wd = File::pushd::pushd($opts->{mint_root});
        for my $cmd (qw( build clean )) {
            local @ARGV = ($cmd);
            Dist::Milla::App->run;
        }
    }

    my $git = Git::Wrapper->new("$opts->{mint_root}");
    $git->add("$opts->{mint_root}");
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
