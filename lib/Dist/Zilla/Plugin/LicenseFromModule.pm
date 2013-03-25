package Dist::Zilla::Plugin::LicenseFromModule;
use Moose;
with 'Dist::Zilla::Role::LicenseProvider';

use Software::LicenseUtils;

sub provide_license {
    my($self, $args) = @_;

    my $content = $self->zilla->main_module->content;

    my $author = $self->author_from($content);
    my $year = $self->copyright_year_from($content);

    my @guess = Software::LicenseUtils->guess_license_from_pod($content);

    if (@guess != 1) {
        $self->log(["Failed to parse license from %s", $self->zilla->main_module->name]);
        return;
    }

    my $license_class = $guess[0];

    $self->log(["guessing from %s, License is %s\nCopyright %s %s",
                $self->zilla->main_module->name, $license_class,
                $year || '(unknown)', $author || '(unknown)']);

    Class::MOP::load_class($license_class);

    return $license_class->new({
        holder => $author || $args->{copyright_holder},
        year   => $year   || $args->{copyright_year},
    });
}

# taken from Module::Install::Metadata::author_from (as well as Minilla)
sub author_from {
    my($self, $content) = @_;

    if ($content =~ m/
        =head \d \s+ (?:authors?)\b \s*
        ([^\n]*)
        |
        =head \d \s+ (?:licen[cs]e|licensing|copyright|legal)\b \s*
        .*? copyright .*? \d\d\d[\d.]+ \s* (?:\bby\b)? \s*
        ([^\n]*)
    /ixms) {
        my $author = $1 || $2;
 
        # XXX: ugly but should work anyway...
        if (eval "require Pod::Escapes; 1") { ## no critics.
            # Pod::Escapes has a mapping table.
            # It's in core of perl >= 5.9.3, and should be installed
            # as one of the Pod::Simple's prereqs, which is a prereq
            # of Pod::Text 3.x (see also below).
            $author =~ s{ E<( (\d+) | ([A-Za-z]+) )> }
            {
                defined $2
                ? chr($2)
                : defined $Pod::Escapes::Name2character_number{$1}
                ? chr($Pod::Escapes::Name2character_number{$1})
                : do {
                    warn "Unknown escape: E<$1>";
                    "E<$1>";
                };
            }gex;
        }
            ## no critic.
        elsif (eval "require Pod::Text; 1" && $Pod::Text::VERSION < 3) {
            # Pod::Text < 3.0 has yet another mapping table,
            # though the table name of 2.x and 1.x are different.
            # (1.x is in core of Perl < 5.6, 2.x is in core of
            # Perl < 5.9.3)
            my $mapping = ($Pod::Text::VERSION < 2)
                ? \%Pod::Text::HTML_Escapes
                : \%Pod::Text::ESCAPES;
            $author =~ s{ E<( (\d+) | ([A-Za-z]+) )> }
            {
                defined $2
                ? chr($2)
                : defined $mapping->{$1}
                ? $mapping->{$1}
                : do {
                    warn "Unknown escape: E<$1>";
                    "E<$1>";
                };
            }gex;
        }
        else {
            $author =~ s{E<lt>}{<}g;
            $author =~ s{E<gt>}{>}g;
        }
        return $author;
    } else {
        warn "Cannot determine author info from @{[ $_[0]->source ]}\n";
        return;
    }
}

sub copyright_year_from {
    my($self, $content) = @_;

    if ($content =~ m/
        =head \d \s+ (?:licen[cs]e|licensing|copyright|legal|authors?)\b \s*
        .*? copyright .*? ([\d\-]+)
    /ixms) {
        return $1;
    }

    return;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;

