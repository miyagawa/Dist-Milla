package Dist::Milla;

use strict;
use version; our $VERSION = version->declare('v1.0.15');

1;
__END__

=encoding utf-8

=head1 NAME

Dist::Milla - Distribution builder, Opinionated but Unobtrusive

=head1 SYNOPSIS

  > milla new Dist-Name
  > cd Dist-Name

  > milla build
  > milla release

=head1 DESCRIPTION

B<Milla is a Dist::Zilla profile>. It is a collection of
L<Dist::Zilla> plugin bundle, minting profile and a command line
wrapper. It is designed around the "Convention over Configuration"
philosophy (Opinionated), and by default doesn't rewrite module files
nor requires you to change your workflow at all (Unobtrusive).

Experienced CPAN authors who know how to write CPAN distributions can
keep writing the code like before, but can remove lots of cruft, then
replace L<Module::Install> and L<ShipIt> with L<Dist::Zilla> and Milla
profile for authoring, while you don't need to I<add> anything other
than a shiny new L<cpanfile> (optional), and a simple C<dist.ini>
saying:

  [@Milla]

=head1 CONVENTIONS

Milla is opinionated. Milla has a slightly bold assumption and
convention like the followings, which are almost compatible to the
sister project L<Minilla>.

=over 4

=item Your module is Pure Perl, and files are stored in C<lib>

=item Your executable file is in C<script> directory, if any

=item Your dist sharedirs must be in C<share> directory, if any

=item Your module is maintained with Git and C<git ls-files> matches with what you will release

=item Your module has a static list of prerequisites that can be described in C<cpanfile>

=item Your module has a Changes file

=back

If you have a module that doesn't work with these conventions, no
worries. Because Milla is just a Dist::Zilla profile, you can just
upgrade to L<Dist::Zilla> and enable/disable plugins that match with
what you need.

=head1 GETTING STARTED

  # First time only
  > cpanm Dist::Milla
  > milla setup

  # Make a new distribution
  > milla new Dist-Name
  > cd Dist-Name

  # git is already initialized and files are added for you
  > git commit -m "initial commit"

  # Hack your code!
  > $EDITOR lib/Dist/Name.pm t/dist-name.t cpanfile

  # (Optional; First time only) Make your build: This will get some boilerplate for git
  > milla build
  > git add Build.PL META.json README.md && git commit -m "git stuff"

  # Done? Test and release it!
  > $EDITOR Changes
  > milla build
  > milla release

It's that easy.

You already have distributions with L<Module::Install>,
L<Module::Build> or L<ShipIt>? Migrating is also trivial. See
L<Dist::Milla::Tutorial/MIGRATING> for more details.

=head1 WHY

=head2 WHY Dist::Zilla

A lot of you might have heard of Dist::Zilla (dzil). If you already
use it and love it, then you can stop reading this, or even using this
module at all.

If you heard of dzil and think it's overkill or doesn't work for your
module, this is why Milla exists.

If you have tried dzil ages ago and thought it was slow, or couldn't
find how to configure it to do what you want it to do, Milla will be
just for you.

First, let me tell you what's the reason to like Dist::Zilla.

Dist::Zilla doesn't do the job of installing of your module. So you
can focus on the authoring side of things with dzil, while letting
MakeMaker or Module::Build(::Tiny) to do the installation side of things. I
like this design. David Golden also has written L<an excellent blog
post|http://www.dagolden.com/index.php/752/why-im-using-distzilla/>
explaining more details about what this means.

That said, I myself have avoided switching to Dist::Zilla for a long
time. I actually tried a couple of times, but ended up giving up
switching to it. You can google for "Hate Dist::Zilla" and will be
able to find rants by similarly frustrated developers.

In my observation, typical problems/dislikes around Dist::Zilla can be
categorized into one of the following thoughts.

=over 4

=item Dist::Zilla is slow

=item Dist::Zilla has too many dependencies

=item Dist::Zilla is obtrusive

=item Dist::Zilla makes contributing difficult

=item Dist::Zilla isn't just worth it

=back

Let's see how we can address them by using Milla, one at a time.

=over 4

=item Dist::Zilla is slow

Moose, the object system Dist::Zilla uses under the hood, has been
improved a lot for the past few years, and your development machine
has got a much better CPU and SSD as well. For me personally, with all
of Milla plugins loaded, C<milla nop> takes roughly 1.5 second, which
I would say is acceptable since I only need to run it at a
distribution creation time and release time. More on that later.

=item Dist::Zilla has too many dependencies

This is true, and Milla doesn't solve that problem, because it I<adds>
more dependencies on top of Dist::Zilla.

For a quickstart with Milla-like distribution building environment
without installing "half of CPAN", see the sister project L<Minilla>.

=item Dist::Zilla is obtrusive

This was my main motivation for not switching to Dist::Zilla - the
thought that using Dist::Zilla would require me to change my workflow.

The truth is, Dist::Zilla doesn't I<require> you to change your
workflow by itself. But a lot of popular plugins and workflow suggests
doing so, by using stuff like PodWeaver, which requires you to switch
to Dist::Zilla for everything and then generate the boilerplate, or
munge your modules from there.

I don't care about the real boilerplate such as C<MANIFEST>,
C<META.json> or C<LICENSE> auto-generated, but don't personally like
the idea of generating documentation or munging code.

I want to edit and maintain all the code and docs myself, and let the
authoring tool figure out metadata I<from> there, not the other way
round.

B<With Milla, you don't need to change your workflow>, and it won't
rewrite your C<.pm> files at all. Like Module::Install's C<all_from>,
most of the metadata is figured out from your module and git,
automatically.

=item Dist::Zilla makes contributing difficult

This is true for most Dist::Zilla based distributions.

Milla copies the plain C<META.json> and C<Build.PL> into the git
repository you automatically bump on every release. And there won't be
any code munging process required for the release (except bumping
C<$VERSION> automatically).

This means that the git repository can be installed as a standard CPAN
distribution even without L<Dist::Zilla> installed, and collaborators
can just hack your modules, run the tests with C<prove -l t> and send
a pull request just like a normal module without using dzil at all.

B<It's just a releaser who has to install and use Milla>.

=item Dist::Zilla isn't just worth it

Dist::Zilla has a lot of plugins to search from, and it's so easy for
you to spend a few days until you settle with the configuration you
need. B<That is exactly why Milla exists>.

If you have tried Dist::Zilla before, you might have shared the same
experience with me, where the default Basic profile doesn't do
much. And when you started wondering or asking what other authors are
doing, you would be overwhelmed by the amount of plugins and
complexity introduced by the clever workflow.

Milla provides a sensible set of defaults that will work for 90% of
people, and you don't need to waste time configuring your PluginBundle
or searching for the plugin you need.

=back

=head2 WHY NOT Module::Install

I loved Module::Install. I love how it automatically figures out what
I want to do with a single C<all_from> line. I liked the cleverness of
its bundling itself into C<inc>. But I know many collaborators hated
it because you have no idea what plugins have to be installed when you
use some funky plugins, and your users are puzzled when they try to
install from the git repository because it says C<Can't locate
inc/Module/Install.pm>. This problem can be fixed, but I was not
interested in doing so.

=head1 FAQ

=head3 So you basically wrote a simple PluginBundle and some wrapper, and give that a name?

Yes. That's the whole point. Think L<Dist::Zilla> as a framework
(because it is!) and Milla is a (thin) application built on top of
that.

=head3 That's so egoistic for you! Why not just Dist::Zilla::PluginBundle::Author::MIYAGAWA?

Part of the reason might be my egoism. But think about it - if I
switched to Dist::Zilla and recommend everyone to use, I have to say,
"Hey, the way I use dzil is kind of cool. You can get that by using my
C<@MIYAGAWA> bundle".

Wouldn't that be more egoistic than giving it a different name?

I wrote my own L<PSGI> implementation, and didn't give it a name
PSGI::MIYAGAWA - it's called L<Plack>. I wrote a kick-ass, lightweight
CPAN installer, and didn't give it a name CPAN::Installer::MIYAGAWA -
it's called L<cpanm>.

Because I I<think> this can be recommended for many people, and want
to make it better by incorporating contributions, I gave it a
different name other than my own personal name bundle.

=head3 Dist::Zilla feels overkill. If you don't munge code/docs, what's the point?

I agree that it is still overkill. But as of this writing, there's no
software other than Dist::Zilla that can correctly create a CPAN style
distribution other than L<ExtUtils::MakeMaker> and L<Module::Build>,
and I think they're wrong tools for I<authoring> distributions.

Check out L<Minilla> if you think Dist::Zilla is overkill and want a
lightweight replacement that achieves the same goal byt does less.

=head3 Milla?

As stated above, I've been loving the cleverness of Module::Install (MI),
but felt its limitation. Milla is an attempt to put Module::Install's
smartness into Dist::Zilla (without the C<inc> mess).

M::I + Zilla = Milla.

Milla should also remind you of Milla Jovovich, but I couldn't make up
any correlation about it, besides Resident Evil is such a great
videogame and movie.

=head1 AUTHOR

Tatsuhiko Miyagawa E<lt>miyagawa@bulknews.netE<gt>

=head1 CONTRIBUTORS

Ricardo SIGNES wrote L<Dist::Zilla>.

David Golden wrote L<Dist::Zilla::PluginBundle::DAGOLDEN>, which I
cargo culted a lot of configuration from, for Milla bundle.

Tokuhiro Matsuno has beaten me to writing L<Minilla>, which resulted
in me going the Dist::Zilla plugin route. L<Minilla> is a sister
project, and we try to make them compatible to each other and make it
as trivial as possible to switch from/to each other.

=head1 COPYRIGHT

Copyright 2013- Tatsuhiko Miyagawa

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Dist::Zilla>, L<Minilla>

=cut
