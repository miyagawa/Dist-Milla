requires 'perl', 5.012;

requires 'Dist::Zilla', 4.300032;
requires 'Module::CPANfile', 0.9025;

requires 'Dist::Zilla::Plugin::CheckChangesHasContent';
requires 'Dist::Zilla::Plugin::ConfirmRelease';
requires 'Dist::Zilla::Plugin::ContributorsFromGit';
requires 'Dist::Zilla::Plugin::CopyFilesFromBuild';
requires 'Dist::Zilla::Plugin::CopyFilesFromRelease';
requires 'Dist::Zilla::Plugin::ExecDir';
requires 'Dist::Zilla::Plugin::ExtraTests';
requires 'Dist::Zilla::Plugin::Git::Init', '2.012'; # commit = 0
requires 'Dist::Zilla::Plugin::Git::GatherDir';
requires 'Dist::Zilla::Plugin::GithubMeta';
requires 'Dist::Zilla::Plugin::License';
requires 'Dist::Zilla::Plugin::LicenseFromModule', '0.05'; # load from .pod too
requires 'Dist::Zilla::Plugin::Manifest';
requires 'Dist::Zilla::Plugin::MetaJSON';
requires 'Dist::Zilla::Plugin::MetaYAML';
requires 'Dist::Zilla::Plugin::ModuleBuildTiny';
requires 'Dist::Zilla::Plugin::NameFromDirectory';
requires 'Dist::Zilla::Plugin::NextRelease';
requires 'Dist::Zilla::Plugin::PodSyntaxTests';
requires 'Dist::Zilla::Plugin::Prereqs::FromCPANfile', '0.06';
requires 'Dist::Zilla::Plugin::ReadmeAnyFromPod';
requires 'Dist::Zilla::Plugin::ReadmeFromPod';
requires 'Dist::Zilla::Plugin::ReversionOnRelease', '0.04';
requires 'Dist::Zilla::Plugin::ShareDir';
requires 'Dist::Zilla::Plugin::Test::Compile';
requires 'Dist::Zilla::Plugin::TestRelease';
requires 'Dist::Zilla::Plugin::UploadToCPAN';
requires 'Dist::Zilla::Plugin::VersionFromModule';
requires 'Dist::Zilla::Role::PluginBundle::Config::Slicer';
requires 'Dist::Zilla::Role::PluginBundle::PluginRemover';
requires 'Dist::Zilla::PluginBundle::Git';

on test => sub {
    requires 'Test::More', '0.88';
};
