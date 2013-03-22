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

sub munge_files {
    my $self = shift;

    return unless $ENV{DZIL_RELEASING};

    my $version = $self->bump_version;
    $self->munge_file($_, $version) for @{ $self->found_files };

    $self->zilla->version("$version");

    return;
}

sub bump_version {
    my $self = shift;

    my $new_ver = Perl::Version->new($self->zilla->version);

    my %BUMP = (
        'auto'       => 'auto',
        'revision'   => 0,
        'version'    => 1,
        'subversion' => 2,
        'alpha'      => 3,
    );

    my $bump_spec = "auto"; # xxx
    my $bump = $BUMP{$bump_spec};

    if ($bump eq 'auto') {
        if ($new_ver->is_alpha) {
            $new_ver->inc_alpha;
        } else {
            my $pos = $new_ver->components - 1;
            $new_ver->increment($pos);
        }
    } else {
        my $pos = $new_ver->components - 1;
        if ($bump > $pos) {
            die "Cannot bump $bump_spec -- version $new_ver does not have "
              . "'$bump' component.\n";
        }
        $new_ver->increment($bump);
    }

    $new_ver;
}

sub version_re_perl {
    my $ver_re = shift;

    return
      qr{ ^ ( .*?  [\$\*] (?: \w+ (?: :: | ' ) )* VERSION \s* = \D*? ) 
                   $ver_re 
                   ( .* ) $ }x;
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

    my $re = version_re_perl(Perl::Version::REGEX);

    my $scanner = $self->filter_pod(sub {
        s{$re}{
            $self->rewrite_version($file, $1, Perl::Version->new($2.$3.$4), $5, $new_ver)
        }e;
    });

    my $munged;

    my @content = split /\n/, $file->content;
    for (@content) {
        $scanner->($_) && $munged++;
    }

    $file->content(join("\n", @content)) if $munged;
}
