package Dist::Zilla::PluginBundle::Mothra;
use Moose;
with 'Dist::Zilla::Role::PluginBundle::Easy';

use namespace::autoclean;

sub configure {
    my $self = shift;

    $self->add_plugins(
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
#        [ 'UploadToCPAN' ],
        [ 'FakeRelease' ],

        [ 'CopyFilesFromRelease', { match => '\.pm$' } ],
        [ 'Git::Commit', {
            commit_msg => "Checking in changes for %v",
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

Dist::Zilla::PluginBundle::Mothra - Dist::Zilla plugin defaults for Mothra

=head1 SYNOPSIS

  # dist.ini
  [@Mothra]

=head1 DESCRIPTION

This is a Dist::Zilla plugin bundle that implements the opinionated build
process of L<Mothra>. Roughly equivalent to:

  # TBD

=head1 SEE ALSO

L<Mothra>

=cut

