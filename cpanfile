requires 'perl', 5.012;

requires 'Dist::Zilla', 6;
requires 'Module::CPANfile', 0.9025;

requires 'Dist::Zilla::Plugin::CheckChangesHasContent';
requires 'Dist::Zilla::Plugin::ConfirmRelease';
requires 'Dist::Zilla::Plugin::CopyFilesFromBuild', '0.163040';
requires 'Dist::Zilla::Plugin::CopyFilesFromRelease';
requires 'Dist::Zilla::Plugin::ExecDir';
requires 'Dist::Zilla::Plugin::ExtraTests';
requires 'Dist::Zilla::Plugin::Git::Contributors', '0.009';
requires 'Dist::Zilla::Plugin::Git::Init', '2.012'; # commit = 0
requires 'Dist::Zilla::Plugin::Git::GatherDir';
requires 'Dist::Zilla::Plugin::GithubMeta';
requires 'Dist::Zilla::Plugin::License';
requires 'Dist::Zilla::Plugin::LicenseFromModule', '0.05'; # load from .pod too
requires 'Dist::Zilla::Plugin::Manifest';
requires 'Dist::Zilla::Plugin::MetaJSON';
requires 'Dist::Zilla::Plugin::MetaYAML';
requires 'Dist::Zilla::Plugin::ModuleBuildTiny';
requires 'Dist::Zilla::Plugin::NameFromDirectory', '0.04';
requires 'Dist::Zilla::Plugin::NextRelease';
requires 'Dist::Zilla::Plugin::PodSyntaxTests';
requires 'Dist::Zilla::Plugin::Prereqs::FromCPANfile', '0.06';
requires 'Dist::Zilla::Plugin::ReadmeAnyFromPod', '0.163250';
requires 'Dist::Zilla::Plugin::ReadmeFromPod', '0.37';
requires 'Dist::Zilla::Plugin::ReversionOnRelease', '0.04';
requires 'Dist::Zilla::Plugin::ShareDir';
requires 'Dist::Zilla::Plugin::StaticInstall';
requires 'Dist::Zilla::Plugin::Test::Compile';
requires 'Dist::Zilla::Plugin::TestRelease';
requires 'Dist::Zilla::Plugin::UploadToCPAN';
requires 'Dist::Zilla::Plugin::VersionFromMainModule';
requires 'Dist::Zilla::Role::PluginBundle::Config::Slicer';
requires 'Dist::Zilla::Role::PluginBundle::PluginRemover';
requires 'Dist::Zilla::PluginBundle::Git';

on test => sub {
    requires 'Test::More', '0.88';
};
