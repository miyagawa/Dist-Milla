# NAME

Dist::Milla - Distribution builder, Opinionated but Unobtrusive

# SYNOPSIS

    > dzil new -P Milla Dist-Name
    > cd Dist-Name

    > dzil build
    > dzil release

# DESCRIPTION

__Milla is a Dist::Zilla profile__. It is a collection of
[Dist::Zilla](http://search.cpan.org/perldoc?Dist::Zilla) plugin bundle, minting profile and a command line
wrapper. It is designed around the "Convention over Configuration"
philosophy (Opinionated), and by default doesn't rewrite module files
nor requires you to change your workflow at all (Unobtrusive).

Experienced CPAN authors who know how to write CPAN distributions can
keep writing the code like before, but can remove lots of cruft, then
replace [Module::Install](http://search.cpan.org/perldoc?Module::Install) and [ShipIt](http://search.cpan.org/perldoc?ShipIt) with [Dist::Zilla](http://search.cpan.org/perldoc?Dist::Zilla) and Milla
profile for authoring, while you don't need to _add_ anything other
than a shiny new [cpanfile](http://search.cpan.org/perldoc?cpanfile) (optional), and a simple `dist.ini`
saying:

    name = Dist-Name
    [@Milla]

and that's it.

# CONVENTIONS

As stated above, Milla is opinionated. Milla has a bold assumption and
convention like the followings, which are almost compatible to the
sister project [Minilla](http://search.cpan.org/perldoc?Minilla).

- Your module is Pure Perl, and files are stored in `lib`
- Your executable file is in `script` directory, if any
- Your module is maintained with Git and `git ls-files` matches with what you will release
- Your module has a static list of prerequisites that can be described in `cpanfile`
- Your module has a Changes file

If you have a module that doesn't work with these conventions, no
worries. Because Milla is just a Dist::Zilla profile, you can just
upgrade to [Dist::Zilla](http://search.cpan.org/perldoc?Dist::Zilla) and enable/disable plugins that match with
what you need.

# GETTING STARTED

    # First time only
    > cpanm Dist::Milla
    > dzil setup

    # Make a new distribution
    > dzil new -P Milla Dist-Name
    > cd Dist-Name

    # Init your git
    > git init && git add . && git commit -m "initial commit"

    # Hack your code!
    > $EDITOR lib/Dist/Name.pm t/dist-name.t cpanfile

    # (Optional; First time only) Make your build: This will get some boilerplate for git
    > dzil build
    > git add Build.PL META.json README.md && git commit -m "git stuff"

    # Done? Test and release it!
    > $EDITOR Changes
    > dzil build
    > dzil release

It's that easy.

You already have distributions with [Module::Install](http://search.cpan.org/perldoc?Module::Install),
[Module::Build](http://search.cpan.org/perldoc?Module::Build) or [ShipIt](http://search.cpan.org/perldoc?ShipIt)? Migrating is also trivial. See
["MIGRATING" in Dist::Milla::Tutorial](http://search.cpan.org/perldoc?Dist::Milla::Tutorial#MIGRATING) for more details.

# WHY

A lot of you might have heard of Dist::Zilla. If you already use it
and love it, then you can stop reading this, or even using this module
at all.

If you heard of dzil and think it's overkill or doesn't work for yor
module, this is why Milla exists.

If you have tried dzil ages ago and thought it was slow, or couldn't
find how to configure it to do what you want it to do, Milla will be
just for you.

First, let me tell you what's the reason to like Dist::Zilla.

Dist::Zilla doesn't do the job of installing of your module. So you
can focus on the authoring side of things with dzil, while letting
MakeMaker or Module::Build(::Tiny) to do the installation side of things. I
like this design. David Golden also has [an excellent blog post](http://www.dagolden.com/index.php/752/why-im-using-distzilla/)
explaining more details about what this means.

That said, I myself have avoided switching to Dist::Zilla for a long
time for some reason. I actually tried a couple of times, but ended up
giving up to swithing it. You can google for "Hate Dist::Zilla" and
will be able to find similarly frustrated developers.

In my observation, typical problems/dislikes around Dist::Zilla can be
categorized into one of the following thoughts.

- Dist::Zilla is slow
- Dist::Zilla has too many dependencies
- Dist::Zilla is obtrusive
- Dist::Zilla makes contributing hard
- Dist::Zilla isn't just worth it

Let's see how we can address them by using Milla, one at a time.

- Dist::Zilla is slow

    Moose has been improved a lot for the past few years, and your
    development machine has got a much better CPU and SSD as well,
    hopefully. For me personally, with all of Milla plugins loaded, `dzil
    nop` takes roughly 1.5 second, which __I would say is acceptable__
    since I only need to run it at a distribution creation time and
    release time. More on that later.

- Dist::Zilla has too many dependencies

    __That is absolutely true__, and Milla doesn't solve that problem.

    For a quickstart with Milla-like distribution building environment
    without installing "half of CPAN", see the sister project [Minilla](http://search.cpan.org/perldoc?Minilla).

- Dist::Zilla is obtrusive

    That was my main motivation for not switching to Dist::Zilla. The
    truth is, Dist::Zilla doesn't _require_ you to change workflow by
    default. But a lot of popular plugins and workflow suggests doing so,
    by using stuff like PodWeaver, which requires you to switch to
    Dist::Zilla for everything and then generate the boilerplate, or munge
    your modules from there.

    I don't care about the real boilerplate such as `MANIFEST`,
    `META.yml` or `LICENSE` auto-generated, but didn't personally like
    the idea of generating documentation or munging code.

    I want to edit and maintain all the code and docs myself, and let the
    authoring tool figure out metadata _from_ there, just like
    [Module::Install](http://search.cpan.org/perldoc?Module::Install)'s `all_from` did. Not the other way round.

    __With Milla, you don't need to change your workflow__, and it won't
    rewrite your precious `.pm` files at all. Like `all_from`, most of
    the metadata is figured out from your module and git, automatically.

- Dist::Zilla makes contributing hard

    That is true for most Dist::Zilla based distributions.

    Milla copies the plain `META.json` and `Build.PL` into the git
    repository you automatically bump on every release. And there won't be
    any code munging process required for the release (except bumping
    `$VERSION` automatically).

    This means the git repository can be installed as a standard CPAN
    distribution even without [Dist::Zilla](http://search.cpan.org/perldoc?Dist::Zilla) installed, and collaborators
    can just hack your modules, run the tests with `prove -l t` and send
    a pull request just like a normal module without using dzil at all.

    __It's just you who has to install Milla__.

- Dist::Zilla isn't just worth it

    Dist::Zilla has a lot of plugins to search from, and it's so easy for
    you to spend a few days until you settle with the configuration you
    need. __That is absolutely true and why Milla exsits__.

    If you have tried Dist::Zilla before, you might have shared the same
    experience with me, where the default Basic profile doesn't do
    much. And when you started wondering what other authors are doing, you
    would be overwhelmed by the amount of plugins and complexicy
    introduced by the clever workflow.

    Milla provides a sensible set of defaults that will work for 90% of
    people, and you don't need to waste time configuring your PluginBundle
    or searching for the plugin you need.

# FAQ

### So you basically wrote a simple PluginBundle and some wrapper, and give that a name?

Yes. That's the whole point. Think [Dist::Zila](http://search.cpan.org/perldoc?Dist::Zila) as a framework
(because it is!) and Milla is a (thin) application built on top of
that.

### That's so egoistic for you! Why not just Dist::Zilla::PluginBundle::Author::MIYAGAWA?

Part of the reason might be my egoism. But think about it - if I
switched to Dist::Zilla and recommend everyone to use, I have to say,
"Hey, the way I use dzil is kind of cool. You can get that by using my
`@MIYAGAWA` bundle".

Wouldn't that be more egoistic than giving it a different name?

I wrote my own [PSGI](http://search.cpan.org/perldoc?PSGI) implementation, and didn't give it a name
PSGI::MIYAGAWA - it's called [Plack](http://search.cpan.org/perldoc?Plack). I wrote a kick-ass, lightweight
CPAN installer, and didn't give it a name CPAN::Installer::MIYAGAWA -
it's called [cpanm](http://search.cpan.org/perldoc?cpanm).

Because I _think_ this can be recommended for many people, and want
to make it better by incorporating contributions, I gave it a
different name other than my own personal name bundle.

### Dist::Zila feels overkill. If you don't munge code/docs, what's the point?

I agree that it is still overkill. But as of this writing, there's no
software other than Dist::Zilla that can correctly create a CPAN style
distribution other than [ExtUtils::MakeMaker](http://search.cpan.org/perldoc?ExtUtils::MakeMaker) and [Module::Build](http://search.cpan.org/perldoc?Module::Build),
and I think they're wrong tool for _authoring_ distributions.

Check out [Minilla](http://search.cpan.org/perldoc?Minilla) if you think Dist::Zilla is overkill and want a
lightweight replacement that does the same thing.

### Milla?

[Minilla](http://search.cpan.org/perldoc?Minilla) is a son of Godzilla. This distribtion builder is just a
Dist::Zilla in the core, but acts like Minilla does. Hence the name
Milla.

Milla should also remind you of Milla Jovovich, but I couldn't make up
any correlation about it, besides Resident Evil is such a great
videogame and movie.

# AUTHOR

Tatsuhiko Miyagawa <miyagawa@bulknews.net>

# CONTRIBUTORS

Ricardo SIGNES wrote [Dist::Zilla](http://search.cpan.org/perldoc?Dist::Zilla).

David Golden wrote [Dist::Zilla::PluginBundle::DAGOLDEN](http://search.cpan.org/perldoc?Dist::Zilla::PluginBundle::DAGOLDEN), which I
cargo culted a lot of configuration from, for Milla bundle.

Tokuhiro Matsuno has beaten me to writing [Minilla](http://search.cpan.org/perldoc?Minilla), which resulted
in me going the Dist::Zilla plugin route. [Minilla](http://search.cpan.org/perldoc?Minilla) is a sister
project, and we try to make them compatible to each other and makes it
as trivial as possible to switch from/to each other.

# COPYRIGHT

Copyright 2013- Tatsuhiko Miyagawa

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEE ALSO

[Dist::Zilla](http://search.cpan.org/perldoc?Dist::Zilla), [Minilla](http://search.cpan.org/perldoc?Minilla)
