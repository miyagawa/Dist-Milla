package Dist::Zilla::PluginBundle::Milla;
use Moose;
with 'Dist::Zilla::Role::PluginBundle::Easy';

use namespace::autoclean;

sub configure {
    my $self = shift;

    $self->add_plugins(
        [ 'NameFromDirectory' ],

        # Make the git repo installable
        [ 'Git::GatherDir', { exclude_filename => [ 'Build.PL', 'META.json', 'README.md' ] } ],
        [ 'CopyFilesFromBuild', { copy => [ 'META.json', 'Build.PL' ] } ],

        # should be after GatherDir
        [ 'VersionFromModule' ],
        [ 'ReversionOnRelease' ],

        # after ReversionOnRelease for munge_files, before Git::Commit for after_release
        [ 'NextRelease' ],

        [ 'Git::Check', { allow_dirty => [ 'dist.ini', 'Changes', 'META.json' ] } ],

        # Make Github center and front
        [ 'GithubMeta', { issues => 1 } ],
        [ 'ReadmeAnyFromPod', { type => 'markdown', filename => 'README.md', location => 'root' } ],

        # cpanfile + MB::Tiny
        [ 'Prereqs::FromCPANfile' ],
        [ 'ModuleBuildTiny' ],
        [ 'MetaJSON' ],

        # standard stuff
        [ 'PodSyntaxTests' ],
        [ 'Test::Compile' ],
        [ 'MetaYAML' ],
        [ 'License' ],
        [ 'ReadmeFromPod' ],
        [ 'ExtraTests' ],
        [ 'ExecDir' ],
        [ 'ShareDir' ],
        [ 'Manifest' ],

        [ 'CheckChangesHasContent' ],
        [ 'TestRelease' ],
        [ 'ConfirmRelease' ],
        [ $ENV{FAKE_RELEASE} ? 'FakeRelease' : 'UploadToCPAN' ],

        [ 'CopyFilesFromRelease', { match => '\.pm$' } ],
        [ 'Git::Commit', {
            commit_msg => '%v',
            allow_dirty => [ 'dist.ini', 'Changes', 'META.json' ],
            allow_dirty_match => '\.pm$', # .pm files copied back from Release
        } ],
        [ 'Git::Tag', { tag_format => '%v', tag_message => '' } ],
        [ 'Git::Push' ],

    );
}

__PACKAGE__->meta->make_immutable;
1;

__END__

=head1 NAME

Dist::Zilla::PluginBundle::Milla - Dist::Zilla plugin defaults for Milla

=head1 SYNOPSIS

  # dist.ini
  [@Milla]

=head1 DESCRIPTION

This is a Dist::Zilla plugin bundle that implements the opinionated build
process of Milla. Roughly equivalent to:

  # TBD

=head1 SEE ALSO

L<Dist::Milla>

=cut

