package Dist::Zilla::Plugin::Milla::MintFiles;
use Moose;
extends 'Dist::Zilla::Plugin::InlineFiles';
with 'Dist::Zilla::Role::TextTemplate';

override 'merged_section_data' => sub {
    my $self = shift;

    my $data = super;

    for my $name (keys %$data) {
        $data->{$name} = \$self->fill_in_string(
            ${ $data->{$name} }, {
                dist => \($self->zilla),
                plugin => \($self),
            },
        );
    }

    return $data;
};

1;
__DATA__
___[ dist.ini ]___
[@Milla]
___[ Changes ]___
Revision history for {{ $dist->name }}

{{ '{{$NEXT}}' }}
        - Initial release
___[ .gitignore ]___
/{{$dist->name}}-*
/.build
/_build*
/Build
MYMETA.*
!META.json
___[ cpanfile ]___
# requires 'Some::Module', 'VERSION';

on test => sub {
    requires 'Test::More', '0.88';
};
___[ t/basic.t ]___
use strict;
use Test::More;
use {{ (my $mod = $dist->name) =~ s/-/::/g; $mod }};

# replace with the actual test
ok 1;

done_testing;
