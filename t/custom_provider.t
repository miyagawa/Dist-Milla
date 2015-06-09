use strict;
use Test::More;
use Dist::Milla::App;

#
my $app = Dist::Milla::App->new;
my ($cmd, $opt, @args) = $app->prepare_command('new');

cmp_ok($opt->{provider}, 'eq', 'Milla', 'Default profile provider is still Milla');

#
my $expected = 'Default';
my ($cmd, $opt, @args) = $app->prepare_command('new', '-P', $expected);

cmp_ok($opt->{provider}, 'eq', $expected, 'Profile provider can be customized with short option -P');

#
my ($cmd, $opt, @args) = $app->prepare_command('new', '--provider', $expected);

cmp_ok($opt->{provider}, 'eq', $expected, 'Profile provider can be customized with long option --provider');

done_testing;
