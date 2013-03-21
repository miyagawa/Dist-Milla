# NAME

Mothra - Distribution builder, Opinionated but Unobtrusive

# SYNOPSIS

    > moth new
    > moth build
    > moth release

See [moth](http://search.cpan.org/perldoc?moth) for more details about the command line usage.

# DESCRIPTION

Mothra is a collection of [Dist::Zilla](http://search.cpan.org/perldoc?Dist::Zilla) plugin bundle, minting
profile and a command line wrapper. It is designed around the
"Convention over Configuration" philosophy (_Opinionated_), and
by default doesn't rewrite module files at all (_Unobtrusive_).

Experienced CPAN authors who know how to write CPAN distributions can
keep writing the code like before, but can remove lots of cruft, then
replace [Module::Install](http://search.cpan.org/perldoc?Module::Install) and [ShipIt](http://search.cpan.org/perldoc?ShipIt) with [Mothra](http://search.cpan.org/perldoc?Mothra) for authoring,
while you don't need to _add_ anything other than a shiny new
[cpanfile](http://search.cpan.org/perldoc?cpanfile) (optional), and a simple `dist.ini` saying:

    name = Dist-Name
    [@Mothra]

and that's it.

# WHY

## Why Dist::Zilla

A lot of you might have heard of Dist::Zilla. If you already use it
and love it, then you can stop reading this. But if you're sick of
maintaing your own PluginBundle and want to switch to someone else's
good practice, you might want to keep reading.

If you heard of dzil and think it's overkill or doesn't work for yor
module, Mothra is probably just for you.

First, let me tell you what's great about Dist::Zilla.

- Dist::Zilla doesn't do the job of installing of your module. So you
can focus on the authoring side of things with dzil, while letting
MakeMaker or Module::Build to do the installation side of things.

    I like this design.

- There are so many plugins made by the great CPAN ecosystem, and you
will most likely find a plugin that is already written, to do what you
want to accomplish.

That said, I myself have avoided switching to Dist::Zilla for a long
time for some reason, and that might be the same with you.

In my observation, typical problems/dislikes around Dist::Zilla can be
categorized into one of the following thoughts.

- Dist::Zilla is slow and heavy because of Moose
- Dist::Zilla requires too many dependencies
- Dist::Zilla requires me to change my workflow
- Dist::Zilla makes contributing to my module on git very hard
- Dist::Zilla has too many plugins to begin with

Let's see how we can address them by using Mothra, one at a time.

- Dist::Zilla is slow and heavy because of Moose

    I think it depends. Moose has been a lot better for the past few
    years, and your development machine has got a much better CPU and SSD
    as well, hopefully. I personally use Macbook Air late 2011 with Core i7
    and SSD, and running \`dzil nop\` with all of Mothra plugins loaded
    takes roughly 1.5 second.

    Because with [Mothra](http://search.cpan.org/perldoc?Mothra), I need to run the Dist::Zilla bit only at a
    distribution creation time and release time (read later), let me say
    it is an acceptable performance.

- Dist::Zilla requires too many dependencies

    Yes, that is true. And Mothra even requires more to enable recommended
    plugins, in total around 160 as of writing this.

    There might probably be a work around this to reduce the number of
    required modules in Mothra in the future, but you have to accept this
    as a reality.

    For a quickstart with Mothra-like distribution building environment
    without installing 150+ CPAN modules, see the sister project [Minilla](http://search.cpan.org/perldoc?Minilla).

- Dist::Zilla requires me to change my workflow

    That was my main motivation for not switching to Dist::Zilla. The
    truth is, Dist::Zilla doesn't _require_ you to change workflow by
    default. But a lot of popular plugins and workflow suggests doing so,
    by using stuff like _PodWeaver_ or _PkgVersion_, which requires you
    to switch to Dist::Zilla for everything and then generate the
    boilerplate from there.

    I don't care about the real boilerplate such as _MANIFEST_,
    _META.yml_ or _LICENSE_ auto-generated, but didn't personally like
    the idea of generating documentation. I want to edit and maintain all
    the code and docs myself, and let the authoring tool figure out
    metadata _from_ there, just like [Module::Install](http://search.cpan.org/perldoc?Module::Install)'s `all_from`
    did. Not the other way round.

    With Mothra, you don't need to change your workflow, and it won't
    rewrite your previous `.pm` files at all.

    Instead of running \`perl Makefile.PL && make dist && cpan-upload\`, you
    just have to run \`moth release\` and it will figure out all the metadata
    required for PAUSE upload for you.

- Dist::Zilla makes contributing to my module on git very hard

    That is true for most Dist::Zilla based distributions, unless the
    author makes a special workaround to commit the relesed build into a
    git as a separate branch etc. Even with that, writing a patch and
    making pull requests couldn't be as simple as before.

    Mothra copies the plain `META.json` and `Build.PL` into the git
    repository you automatically bump on every release. This means the
    git repository can be installed as a standard CPAN distribution
    even without [Dist::Zilla](http://search.cpan.org/perldoc?Dist::Zilla) installed, and collaborators can just
    hack your modules, run the tests with `prove -l t` and send a
    pull request just like a normal module.

    It's just you who has to install Mothra.

- Dist::Zilla has too many plugins to begin with

    That is absolutely right and why Mothra exsits, so that you don't need
    to waste time configuring your PluginBundle or searching for the
    plugin you need.

# FAQ

### So you basically wrote a simple PluginBundle and some wrapper, and give that a name?

Yes. That's the whole point.

### That's so egoistic for you! Why not just Dist::Zilla::PluginBundle::Author::MIYAGAWA?

Part of the reason might be my egoism. But think about it - if I
switched to Dist::Zilla and recommend everyone to use, I have to say,
"Hey, the way I use dzil is kind of cool. You can get that by using my
`@MIYAGAWA` bundle".

Wouldn't that be more egoistic than giving it a different name?

I wrote my own [PSGI](http://search.cpan.org/perldoc?PSGI) implementation, and didn't give it a name
"PSGI::MIYAGAWA" - it's called [Plack](http://search.cpan.org/perldoc?Plack). I wrote a kick-ass, tiny CPAN
installer, and didn't give it a name "CPAN::Installer::MIYAGAWA" -
it's called [cpanm](http://search.cpan.org/perldoc?cpanm).

Because I _think_ this can be recommended for many people, and want
to make it better by incorporating contributions, I gave it a
different name other than my own personal name bundle.

### Mothra? What is it?

Glad you're asking. From Wikipedia:

    Mothra is a kaiju, a type of fictional monster [...] a giant
    lepidopteran with characteristics both of butterflies and of
    moths.

    She is occasionally an ally to Godzilla but more often than not
    engaged in conflict due to his anger toward the human race. Mothra
    holds the most victories against the "King of Monsters." Mothra
    has never defeated Godzilla on her own, however. In each of these
    victories, Mothra had an ally; [...]

When you replace _Godzilla_ with _Dist::Zilla_, it made me giggle to
read this. While I wouldn't say that dzil has its anger toward the
human race, Mothra can ease your fear against it :)

### But moth? really?

I'm aware that a CLI `moth` might not be the most pleasant command to
type. It's just a convenience to make the command as short and easy to
remember and type as possible.

If you really mind it, feel free to alias it to the full `mothra` :)

# AUTHOR

Tatsuhiko Miyagawa <miyagawa@bulknews.net>

# COPYRIGHT

Copyright 2013- Tatsuhiko Miyagawa

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEE ALSO

[Dist::Zilla](http://search.cpan.org/perldoc?Dist::Zilla), [Minilla](http://search.cpan.org/perldoc?Minilla)
