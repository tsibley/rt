
use strict;
use warnings;

use RT::Test nodb => 1, tests => undef;

RT->Config->Set( RTAddressRegexp => qr/^rt\@example.com$/i );


ok(require RT::EmailParser);

is(RT::EmailParser::IsRTAddress("","rt\@example.com"),1, "Regexp matched rt address" );
is(RT::EmailParser::IsRTAddress("","frt\@example.com"),undef, "Regexp didn't match non-rt address" );

my @before = ("rt\@example.com", "frt\@example.com");
my @after = ("frt\@example.com");
ok(eq_array(RT::EmailParser->CullRTAddresses(@before),@after), "CullRTAddresses only culls RT addresses");

{
    my ( $addr ) =
      RT::EmailParser->ParseEmailAddress('foo@example.com');
    is( $addr->address, 'foo@example.com', 'addr for foo@example.com' );
    is( $addr->phrase,  undef,             'no name for foo@example.com' );

    ( $addr ) =
      RT::EmailParser->ParseEmailAddress('Foo <foo@example.com>');
    is( $addr->address, 'foo@example.com', 'addr for Foo <foo@example.com>' );
    is( $addr->phrase,  'Foo',             'name for Foo <foo@example.com>' );

    ( $addr ) =
      RT::EmailParser->ParseEmailAddress('foo@example.com (Comment)');
    is( $addr->address, 'foo@example.com', 'addr for foo@example.com (Comment)' );
    is( $addr->phrase,  undef,             'no name for foo@example.com (Comment)' );
}

done_testing;
