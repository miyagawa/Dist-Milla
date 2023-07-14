package Dist::Zilla::PluginBundle::Milla;

use strict;
use version; our $VERSION = version->declare('v1.0.22');

use Dist::Milla;
use Moose;
with 'Dist::Zilla::Role::PluginBundle::Easy',
     'Dist::Zilla::Role::PluginBundle::PluginRemover',
     'Dist::Zilla::Role::PluginBundle::Config::Slicer';

use namespace::autoclean;

has installer => (
    is => 'ro',
    isa => 'Str',
    lazy => 1,
    default => sub { $_[0]->payload->{installer} || 'ModuleBuildTiny' },
);

sub build_file {
    my $self = shift;
    $self->installer =~ /MakeMaker/ ? 'Makefile.PL' : 'Build.PL';
}

sub configure {
    my $self = shift;

    my @accepts = qw( MakeMaker MakeMaker::IncShareDir ModuleBuild ModuleBuildTiny );
    my %accepts = map { $_ => 1 } @accepts;

    unless ($accepts{$self->installer}) {
        die sprintf("Unknown installer: '%s'. " .
                    "Acceptable values are MakeMaker, ModuleBuild and ModuleBuildTiny\n",
                    $self->installer);
    }

    my @dirty_files = ('dist.ini', 'Changes', 'META.json', 'README.md', 'LICENSE', $self->build_file);
    my @exclude_release = ('README.md');

    $self->add_plugins(
        [ 'NameFromDirectory' ],

        # Make the git repo installable
        [ 'Git::GatherDir', { exclude_filename => [ $self->build_file, 'META.json', 'LICENSE', @exclude_release ] } ],
        [ 'CopyFilesFromBuild', { copy => [ 'META.json', 'LICENSE', $self->build_file ] } ],

        # should be after GatherDir
        # Equivalent to Module::Install's version_from, license_from and author_from
        [ 'VersionFromMainModule' ],
        [ 'LicenseFromModule', { override_author => 1 } ],

        [ 'ReversionOnRelease', { prompt => 1 } ],

        # after ReversionOnRelease for munge_files, before Git::Commit for after_release
        [ 'NextRelease', { format => '%v  %{yyyy-MM-dd HH:mm:ss VVV}d' } ],

        [ 'Git::Check', { allow_dirty => \@dirty_files } ],

        # Make Github center and front
        [ 'GithubMeta', { issues => 1 } ],
        [ 'ReadmeAnyFromPod', { type => 'markdown', filename => 'README.md', location => 'root' } ],

        # Set no_index to sensible directories
        [ 'MetaNoIndex', { directory => [ qw( t xt inc share eg examples ) ] } ],

        # cpanfile -> META.json
        [ 'Prereqs::FromCPANfile' ],
        [ $self->installer ],
        [ 'MetaJSON' ],

        # experimental dist metadata
        [ 'StaticInstall', { mode => 'auto' } ],

        # Advertise Milla
        [ 'Milla::MetaGeneratedBy' ],

        # x_contributors for MetaCPAN
        [ 'Git::Contributors' ],

        # add Milla itself as a develop dependency
        [ 'Prereqs', { -phase => 'develop', 'Dist::Milla' => Dist::Milla->VERSION } ],

        # standard stuff
        [ 'PodSyntaxTests' ],
        [ 'MetaYAML' ],
        [ 'License' ],
        [ 'ReadmeAnyFromPod', 'ReadmeAnyFromPod/ReadmeTextInBuild' ],
        [ 'ExtraTests' ],
        [ 'ExecDir', { dir => 'script' } ],
        [ 'ShareDir' ],
        [ 'Manifest' ],
        [ 'ManifestSkip' ],

        [ 'CheckChangesHasContent' ],
        [ 'TestRelease' ],
        [ 'ConfirmRelease' ],
        [ $ENV{FAKE_RELEASE} ? 'FakeRelease' : 'UploadToCPAN' ],

        [ 'CopyFilesFromRelease', { match => '\.pm$' } ],
        [ 'Git::Commit', {
            commit_msg => '%v',
            allow_dirty => \@dirty_files,
            allow_dirty_match => '\.pm$', # .pm files copied back from Release
        } ],
        [ 'Git::Tag', { tag_format => '%v', tag_message => '' } ],
        [ 'Git::Push', { remotes_must_exist => 0 } ],

    );
}

__PACKAGE__->meta->make_immutable;
1;

__END__

=head1 NAME

Dist::Zilla::PluginBundle::Milla - Dist::Zilla plugin defaults for Milla

=head1 SYNOPSIS

  ; dist.ini
  name = Dist-Name
  [@Milla]
  installer = MakeMaker

=head1 DESCRIPTION

This is a Dist::Zilla plugin bundle that implements the opinionated build
process of Milla. Roughly equivalent to:

  Variables first:
  $INSTALLER  = installer from Milla options or ModuleBuildTiny
  $BUILD_FILE = ( $INSTALLER =~ /MakeMaker/ ) ? 'Makefile.PL' : 'Build.PL'
  $RELEASE_TO = ( $ENV{FAKE_RELEASE} )        ? 'FakeRelease' : 'UploadToCPAN';

  [NameFromDirectory]
  [Git::GatherDir]
  exclude_filename = $BUILD_FILE
  exclude_filename = META.json
  exclude_filename = LICENSE
  exclude_filename = README.md
  [CopyFilesFromBuild]
  copy = META.json
  copy = $BUILD_FILE
  copy = LICENSE
  [VersionFromMainModule]
  [LicenseFromModule]
  override_author = 1
  [ReversionOnRelease]
  prompt = 1
  [NextRelease]
  format = '%v  %{yyyy-MM-dd HH:mm:ss VVV}d'
  [Git::Check]
  allow_dirty = dist.ini
  allow_dirty = Changes
  allow_dirty = META.json
  allow_dirty = README.md
  allow_dirty = $BUILD_FILE
  [GithubMeta]
  issues = 1
  [ReadmeAnyFromPod]
  type = markdown
  filename = README.md
  location = root
  [MetaNoIndex]
  directory = t
  directory = xt
  directory = inc
  directory = share
  directory = eg
  directory = examples
  [Prereqs::FromCPANfile]
  [$INSTALLER]
  [MetaJSON]
  [Milla::MetaGeneratedBy]
  [Git::Contributors]
  [Prereqs]
  -phase = develop
  Dist::Mill = $CURRENT_DIST_MILLA_VERSION
  [PodSyntaxTests]
  [MetaYAML]
  [License]
  [ReadmeAnyFromPod]
  [ReadmeAnyFromPod/ReadmeTextInBuild]
  [ExtraTests]
  [ExecDir]
  dir = script
  [ShareDir]
  [Manifest]
  [ManifestSkip]
  [CheckChangesHasContent]
  [TestRelease]
  [ConfirmRelease]
  [$RELEASE_TO]
  [CopyFilesFromRelease]
  match = \.pm$
  [Git::Commit]
  commit_msg = '%v'
  allow_dirty = dist.ini
  allow_dirty = Changes
  allow_dirty = META.json
  allow_dirty = README.md
  allow_dirty = $BUILD_FILE
  allow_dirty_match = \.pm$
  [Git::Tag]
  tag_format  = '%v'
  tag_message = ''
  [Git::Push]
  remotes_must_exist = 0

=head1 SEE ALSO

L<Dist::Milla>

L<NameFromDirectory|Dist::Zilla::Plugin::NameFromDirectory>, L<Git::GatherDir|Dist::Zilla::Plugin::Git::GatherDir>, L<CopyFilesFromBuild|Dist::Zilla::Plugin::CopyFilesFromBuild>, L<VersionFromMainModule|Dist::Zilla::Plugin::VersionFromMainModule>, L<LicenseFromModule|Dist::Zilla::Plugin::LicenseFromModule>, L<ReversionOnRelease|Dist::Zilla::Plugin::ReversionOnRelease>, L<NextRelease|Dist::Zilla::Plugin::NextRelease>, L<Git::Check|Dist::Zilla::Plugin::Git::Check>, L<GithubMeta|Dist::Zilla::Plugin::GithubMeta>, L<ReadmeAnyFromPod|Dist::Zilla::Plugin::ReadmeAnyFromPod>, L<MetaNoIndex|Dist::Zilla::Plugin::MetaNoIndex>, L<Prereqs::FromCPANfile|Dist::Zilla::Plugin::Prereqs::FromCPANfile>, L<MetaJSON|Dist::Zilla::Plugin::MetaJSON>, L<Milla::MetaGeneratedBy|Dist::Zilla::Plugin::Milla::MetaGeneratedBy>, L<Git::Contributors|Dist::Zilla::Plugin::Git::Contributors>, L<Prereqs|Dist::Zilla::Plugin::Prereqs>, L<PodSyntaxTests|Dist::Zilla::Plugin::PodSyntaxTests>, L<MetaYAML|Dist::Zilla::Plugin::MetaYAML>, L<License|Dist::Zilla::Plugin::License>, L<ReadmeAnyFromPod|Dist::Zilla::Plugin::ReadmeAnyFromPod>, L<ExtraTests|Dist::Zilla::Plugin::ExtraTests>, L<ExecDir|Dist::Zilla::Plugin::ExecDir>, L<ShareDir|Dist::Zilla::Plugin::ShareDir>, L<Manifest|Dist::Zilla::Plugin::Manifest>, L<ManifestSkip|Dist::Zilla::Plugin::ManifestSkip>, L<CheckChangesHasContent|Dist::Zilla::Plugin::CheckChangesHasContent>, L<TestRelease|Dist::Zilla::Plugin::TestRelease>, L<ConfirmRelease|Dist::Zilla::Plugin::ConfirmRelease>, L<CopyFilesFromRelease|Dist::Zilla::Plugin::CopyFilesFromRelease>, L<Git::Commit|Dist::Zilla::Plugin::Git::Commit>, L<Git::Tag|Dist::Zilla::Plugin::Git::Tag>, L<Git::Push|Dist::Zilla::Plugin::Git::Push>

=cut
