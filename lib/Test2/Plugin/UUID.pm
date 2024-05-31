package Test2::Plugin::UUID;
use strict;
use warnings;

our $VERSION = '0.002006';

use Carp qw/croak/;
use Test2::API qw/test2_add_uuid_via/;
require Test2::Util::UUID;

sub import {
    my $class = shift;

    $class->apply_plugin(@_);

    return;
}

sub apply_plugin {
    my $class = shift;

    my ($gen_uuid, $backend) = Test2::Util::UUID->get_gen_uuid(@_);

    test2_add_uuid_via($gen_uuid);
    require Test2::Hub;
    Test2::Hub->new; # Make sure the UUID generator is found

    return $backend->();
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

=head1 CONTROLLING WARNINGS AND BACKENDS

You can turn off backend warnings, and choose your own backend order
preference:

    use Test2::Plugin::UUID warn => 0, backends => ['UUID', ...];

Or at the command line:

    perl -MTest2::Plugin::UUID=warn,0 path/to/test.t

Or via env vars:

    TEST2_UUID_BACKEND="UUID,Data::UUID::MT" TEST2_UUID_WARN=0 perl path/to/test.t

Normally warnings will be issued if L<UUID::Tiny> or L<Data::UUID> are used as
the first is slow and the second is not suitible for database keys.

=head1 BACKENDS

One of the following modules will be used under the hood, they are listed here
in order of preference.

=over 4

=item L<UUID> >= 0.35

When possible this module will use the L<UUID> cpan module, but it must be
version 0.35 or greater to avoid a fork related bug. It will generate version 7
UUIDs as they are most suitible for database entry.

=item L<Data::UUID::MT>

L<Data::UUID::MT> is the second choice for UUID generation. With this module
version 4 UUIDs are generated as they are fairly usable in databases.

=item L<UUID::Tiny> - slow

L<UUID::Tiny> is used if the previous 2 are not available. This module is pure
perl and thus could be slower than the others. Version 4 UUIDs are generated
when this module is used.

A warning will be issued with this module. You can surpress the warning with
either the C<$TEST2_UUID_NO_WARN> environment variable or the C<< warn => 0 >>
import argument.

=item L<Data::UUID> - Not Suitible for Databases

This is the last resort module. This generates UUIDs fast, but they are of a
type/version that is not suitible for database keys.

A warning will be issued with this module. You can surpress the warning with
either the C<$TEST2_UUID_NO_WARN> environment variable or the C<< warn => 0 >>
import argument.

=back

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

Copyright Chad Granum E<lt>exodist@cpan.orgE<gt>.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

See F<http://dev.perl.org/licenses/>

=cut
