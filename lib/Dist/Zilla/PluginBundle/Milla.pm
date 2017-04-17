package Dist::Zilla::PluginBundle::Milla;

use strict;
use version; our $VERSION = version->declare('v1.0.17');

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

    my $dirty_config = $self->config_slice(qw( add_files_in allow_dirty allow_dirty_match ));
    my @dirty_files = ('dist.ini', 'Changes', 'META.json', 'README.md', $self->build_file, @{$dirty_config->{allow_dirty} || []});
    my @dirty_matches = @{$dirty_config->{allow_dirty_match} || []};
    my @additional_paths = @{$dirty_config->{add_files_in} || []};
    my @exclude_release = ('README.md');

    $self->add_plugins(
        [ 'NameFromDirectory' ],

        # Make the git repo installable
        [ 'Git::GatherDir', { exclude_filename => [ $self->build_file, 'META.json', 'LICENSE', @exclude_release ] } ],
        [ 'CopyFilesFromBuild', { copy => [ 'META.json', 'LICENSE', $self->build_file ] } ],

        # should be after GatherDir
        # Equivalent to Module::Install's version_from, license_from and author_from
        [ 'VersionFromModule' ],
        [ 'LicenseFromModule', { override_author => 1 } ],

        [ 'ReversionOnRelease', { prompt => 1 } ],

        # after ReversionOnRelease for munge_files, before Git::Commit for after_release
        [ 'NextRelease', { format => '%v  %{yyyy-MM-dd HH:mm:ss VVV}d' } ],

        [ 'Git::Check', {
            allow_dirty => \@dirty_files,
            (@dirty_matches ? (allow_dirty_match => \@dirty_matches) : ()),
        } ],

        # Make Github center and front
        [ 'GithubMeta', { issues => 1 } ],
        [ 'ReadmeAnyFromPod', { type => 'markdown', filename => 'README.md', location => 'root' } ],

        # Set no_index to sensible directories
        [ 'MetaNoIndex', { directory => [ qw( t xt inc share eg examples ) ] } ],

        # cpanfile -> META.json
        [ 'Prereqs::FromCPANfile' ],
        [ $self->installer ],
        [ 'MetaJSON' ],

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
            allow_dirty_match => [@dirty_matches, '\.pm$'], # .pm files copied back from Release
            (@additional_paths ? (add_files_in => \@additional_paths) : ()),
        } ],
        [ 'Git::Tag', { tag_format => '%v', tag_message => '' } ],
        [ 'Git::Push', { remotes_must_exist => 0 } ],

    );
}

sub mvp_multivalue_args { qw( add_files_in allow_dirty allow_dirty_match ) }

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
  allow_dirty = some/autoupdated/file
  allow_dirty = some/autoupdated/otherfile
  allow_dirty_match = ^auto/gen-
  add_files_in = some/auto/directory


=head1 DESCRIPTION

This is a Dist::Zilla plugin bundle that implements the opinionated build
process of Milla. Roughly equivalent to:

  # TBD

=head1 SEE ALSO

L<Dist::Milla>

=cut

