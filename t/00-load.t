#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Dist::Zilla::Plugin::GithubCreate' ) || print "Bail out!
";

}

diag( "Testing Dist::Zilla::Plugin::GithubCreate $Dist::Zilla::Plugin::GithubCreate::VERSION, Perl $], $^X" );
