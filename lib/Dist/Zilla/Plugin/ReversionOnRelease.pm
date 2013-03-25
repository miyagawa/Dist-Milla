package Dist::Zilla::Plugin::ReversionOnRelease;
use strict;

use Perl::Version;
use Moose;
with(
    'Dist::Zilla::Role::FileMunger',
    'Dist::Zilla::Role::FileFinderUser' => {
        default_finders => [ ':InstallModules', ':ExecFiles' ],
    },
);

has 'prompt' => (is => 'ro', isa => 'Bool', default => 0);

# from perl-reversion
my $VersionRegexp = Perl::Version::REGEX;
$VersionRegexp =
  qr{ ^ ( .*?  [\$\*] (?: \w+ (?: :: | ' ) )* VERSION \s* = \D*? ) 
                $VersionRegexp
                ( .* ) $ }x;


sub munge_files {
    my $self = shift;

    return unless $ENV{DZIL_RELEASING};

    my $version = $self->reversion;

    if ($self->prompt) {
        my $given_version = $self->zilla->chrome->prompt_str(
            "Next release version? ", {
                default => "$version",
                check => sub {
                    eval { Perl::Version->new($_[0]); 1 },
                },
            },
        );

        $version->set($given_version);
    }

    $self->munge_file($_, $version) for @{ $self->found_files };
    $self->zilla->version("$version");

    return;
}

sub reversion {
    my $self = shift;

    my $new_ver = Perl::Version->new($self->zilla->version);

    if ($ENV{V}) {
        $self->log("Overriding VERSION to $ENV{V}");
        $new_ver->set($ENV{V});
    } elsif ($self->is_released($new_ver)) {
        $self->log_debug("$new_ver is released. Bumping it");
        if ($new_ver->is_alpha) {
            $new_ver->inc_alpha;
        } else {
            my $pos = $new_ver->components - 1;
            $new_ver->increment($pos);
        }
    } else {
        $self->log_debug("$new_ver is not released yet. No need to bump");
    }

    $new_ver;
}

sub is_released {
    my($self, $new_ver) = @_;

    my $changes_file = 'Changes';

    if (! -e $changes_file) {
        $self->log("No $changes_file found in your directory: Assuming $new_ver is released.");
        return 1;
    }

    my $changelog = Dist::Zilla::File::OnDisk->new({ name => $changes_file });

    grep /^$new_ver(?:-TRIAL)?(?:\s+|$)/,
      split /\n/, $changelog->content;
}

sub filter_pod {
    my($self, $cb) = @_;

    my $in_pod;

    return sub {
        my $line = shift;

        if ($in_pod) {
            /^=cut/ and do { $in_pod = 0; return };
        } else {
            /^=(?!cut)/ and do { $in_pod = 1; return };
            return $cb->($line);
        }
    };
}

sub rewrite_version {
    my($self, $file, $pre, $ver, $post, $new_ver) = @_;

    my $current = $self->zilla->version;

    if (defined $current && $current ne $ver) {
        $self->log([ 'Skipping: "%s" has different $VERSION: %s != %s', $file->name, $ver, $current ]);
        return $pre . $ver . $post;
    }

    $self->log([ 'Bumping $VERSION in %s to %s', $file->name, "$new_ver" ]);

    return $pre . $new_ver . $post;
}

sub munge_file {
    my($self, $file, $new_ver) = @_;

    my $scanner = $self->filter_pod(sub {
        s{$VersionRegexp}{
            $self->rewrite_version($file, $1, Perl::Version->new($2.$3.$4), $5, $new_ver)
        }e;
    });

    my $munged;

    my @content = split /\n/, $file->content, -1;
    for (@content) {
        $scanner->($_) && $munged++;
    }

    $file->content(join("\n", @content)) if $munged;
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;
