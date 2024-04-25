package Test2::Plugin::UUID;
use strict;
use warnings;

our $VERSION = '0.002003';

use Test2::API qw/test2_add_uuid_via/;

use Data::UUID;
my $UG = Data::UUID->new;

# OSSP::UUID (Debian) produces lowercase UUIDs, consistently uppercase.
sub gen_uuid() { uc $UG->create_str() }

sub import {
    test2_add_uuid_via(\&gen_uuid);
    require Test2::Hub;
    Test2::Hub->new; # Make sure the UUID generator is found
    return;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Test2::Plugin::UUID - Use REAL UUIDs in Test2

=head1 DESCRIPTION

Test2 normally uses unique IDs generated by appending pid, thread-id, and an
incrementing integer. These work fine most of the time, but are not sufficient
if you want to keep a database of events, in that case a real UUID is much more
useful.

=head1 SYNOPSIS

    use Test2::Plugin::UUID;

This is also useful at the command line for 1-time use:

    $ perl -MTest2::Plugin::UUID path/to/test.t

=head1 SOURCE

The source code repository for Test2-Plugin-UUID can be found at
F<https://github.com/Test-More/Test2-Plugin-UUID/>.

=head1 MAINTAINERS

=over 4

=item Chad Granum E<lt>exodist@cpan.orgE<gt>

=back

=head1 AUTHORS

=over 4

=item Chad Granum E<lt>exodist@cpan.orgE<gt>

=back

=head1 COPYRIGHT

Copyright 2019 Chad Granum E<lt>exodist@cpan.orgE<gt>.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

See F<http://dev.perl.org/licenses/>

=cut
