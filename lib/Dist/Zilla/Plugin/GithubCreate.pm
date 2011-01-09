package Dist::Zilla::Plugin::GithubCreate;
BEGIN {
  $Dist::Zilla::Plugin::GithubCreate::VERSION = '0.02';
}

use Moose;
use File::Basename;

use warnings;
use strict;

with 'Dist::Zilla::Role::AfterMint';

has login => (
	is      => 'ro',
	isa     => 'Str',
);

has token => (
	is   	=> 'ro',
	isa  	=> 'Str',
);

has private => (
	is   	=> 'ro',
	isa  	=> 'Bool',
	default	=> 1
);

=head1 NAME

Dist::Zilla::Plugin::GithubCreate - Create GitHub repo on dzil new

=head1 VERSION

version 0.02

=head1 SYNOPSIS

In your F<profile.ini>:

    [GithubCreate]
    login  = LoginName
    token  = asd324asd34fdqs23d432cf4q
    public = 1

=head1 DESCRIPTION

This Dist::Zilla plugin creates a new git repository on GitHub.com when
a new distribution is created with C<dzil new>.

=cut

sub after_mint {
	my $self 	= shift;
	my ($opts) 	= @_;
	my $repo_name 	= basename($opts -> {mint_root});
	my $base_url	= 'http://github.com/api/v2/json';

	$self -> log("Creating new GitHub repository '$repo_name'");

	if (!$self -> login || !$self -> token) {
		$self -> log("Err: Provide valid GitHub login values");
		return;
	}

	my $browser = LWP::UserAgent -> new;
	$browser -> credentials(
		'github.com:80',
		'',
		$self -> login.'/token' => $self -> token
	);

	my $url 	= "$base_url/repos/create";
	my $response 	= $browser -> request(POST $url, [public => !$self -> private]) -> as_string;
	my $status  	= (split / /,(split /\n/, $response)[0])[1];

	if ($status == 401) {
		$self -> log("Err: Not authorized");
	}
}

=head1 ATTRIBUTES

=over

=item C<login>

The GitHub login name. It is required.

=item C<token>

The GitHub API token for the user. It is required.

=item C<public>

Create a public repository if this is '1' (default), else create a private one.

=back

=head1 AUTHOR

Alessandro Ghedini <alexbio@cpan.org>

=head1 BUGS

Please report any bugs or feature requests at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Dist-Zilla-Plugin-GithubCreate>.
I will be notified, and then you'll automatically be notified of progress
on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Dist::Zilla::Plugin::GithubCreate

You can also look for information at:

=over 4

=item * GitHub page

L<http://github.com/AlexBio/Dist-Zilla-Plugin-GithubCreate>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Dist-Zilla-Plugin-GithubCreate>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Dist-Zilla-Plugin-GithubCreate>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Dist-Zilla-Plugin-GithubCreate>

=item * Search CPAN

L<http://search.cpan.org/dist/Dist-Zilla-Plugin-GithubCreate/>

=back

=head1 LICENSE AND COPYRIGHT

Copyright 2011 Alessandro Ghedini.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

1; # End of Dist::Zilla::Plugin::GithubCreate