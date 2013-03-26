
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  "build_requires" => {
    "Module::Build" => "0.3601"
  },
  "configure_requires" => {
    "Module::Build" => "0.3601"
  },
  "dist_abstract" => "Distribution builder, Opinionated but Unobtrusive",
  "dist_author" => [
    "Tatsuhiko Miyagawa <miyagawa\@bulknews.net>"
  ],
  "dist_name" => "Dist-Milla",
  "dist_version" => "v0.1.13",
  "license" => "perl",
  "module_name" => "Dist::Milla",
  "recommends" => {},
  "recursive_test_files" => 1,
  "requires" => {
    "Dist::Zilla" => "4.3",
    "Dist::Zilla::Plugin::CheckChangesHasContent" => 0,
    "Dist::Zilla::Plugin::ConfirmRelease" => 0,
    "Dist::Zilla::Plugin::CopyFilesFromBuild" => 0,
    "Dist::Zilla::Plugin::CopyFilesFromRelease" => 0,
    "Dist::Zilla::Plugin::ExecDir" => 0,
    "Dist::Zilla::Plugin::ExtraTests" => 0,
    "Dist::Zilla::Plugin::Git::GatherDir" => 0,
    "Dist::Zilla::Plugin::GithubMeta" => 0,
    "Dist::Zilla::Plugin::License" => 0,
    "Dist::Zilla::Plugin::Manifest" => 0,
    "Dist::Zilla::Plugin::MetaJSON" => 0,
    "Dist::Zilla::Plugin::MetaYAML" => 0,
    "Dist::Zilla::Plugin::ModuleBuildTiny" => 0,
    "Dist::Zilla::Plugin::NameFromDirectory" => 0,
    "Dist::Zilla::Plugin::NextRelease" => 0,
    "Dist::Zilla::Plugin::PodSyntaxTests" => 0,
    "Dist::Zilla::Plugin::Prereqs::FromCPANfile" => 0,
    "Dist::Zilla::Plugin::ReadmeAnyFromPod" => 0,
    "Dist::Zilla::Plugin::ReadmeFromPod" => 0,
    "Dist::Zilla::Plugin::ShareDir" => 0,
    "Dist::Zilla::Plugin::Test::Compile" => 0,
    "Dist::Zilla::Plugin::TestRelease" => 0,
    "Dist::Zilla::Plugin::UploadToCPAN" => 0,
    "Dist::Zilla::Plugin::VersionFromModule" => 0,
    "Dist::Zilla::PluginBundle::Git" => 0,
    "Dist::Zilla::Role::PluginBundle::Config::Slicer" => 0,
    "Module::CPANfile" => "0.9025",
    "perl" => "5.008001"
  },
  "script_files" => [
    "script/milla"
  ],
  "share_dir" => {
    "module" => {
      "Dist::Zilla::MintingProfile::Milla" => "profiles"
    }
  }
);


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
