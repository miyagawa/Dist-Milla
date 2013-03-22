package Dist::Zilla::PluginBundle::Mothra;
use Moose;
with 'Dist::Zilla::Role::PluginBundle::Easy';

use namespace::autoclean;

sub configure {
    my $self = shift;

    $self->add_plugins(
        [ 'NextRelease' ], # should be before Git::Commit

        # Make the git repo installable
        [ 'Git::GatherDir', { exclude_filename => [ 'Build.PL', 'META.json', 'README.md' ] } ],
        [ 'CopyFilesFromBuild', { copy => [ 'META.json', 'Build.PL' ] } ],

        # should be after GatherDir
        [ 'VersionFromModule' ],
        [ 'ReversionOnRelease' ],

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
        [ 'Git::Commit' ],
        [ 'Git::Tag' ],
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

  ; I like to keep .pm files intact in git repo
  ; use perl-reversion before making a release
  [VersionFromModule]
  
  [NextRelease] ; should be before Git::Commit
  
  ; Make the git repo installable
  [Git::GatherDir]
  exclude_filename = Build.PL
  exclude_filename = META.json
  exclude_filename = README.md
  [CopyFilesFromBuild]
  copy = META.json
  copy = Build.PL
  [@Git]
  allow_dirty = dist.ini
  allow_dirty = Changes
  allow_dirty = META.json
  
  ; Make Github center and front
  [GithubMeta]
  issues = 1
  [ReadmeAnyFromPod]
  type = markdown
  filename = README.md
  location = root
  
  ; cpanfile + MB::Tiny
  [Prereqs::FromCPANfile]
  [ModuleBuildTiny]
  [MetaJSON]
  
  ; standard stuff
  [PodSyntaxTests]
  [Test::Compile]
  
  [MetaYAML]
  [License]
  [ReadmeFromPod]
  [ExtraTests]
  [ExecDir]
  [ShareDir]
  [Manifest]
  
  [CheckChangesHasContent]
  [TestRelease]
  [ConfirmRelease]
  [UploadToCPAN]

=head1 SEE ALSO

L<Mothra>

=cut

