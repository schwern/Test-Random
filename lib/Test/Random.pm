package Test::Random;

use strict;
use warnings;

our $VERSION = 20100119;

my $Seed = defined $ENV{TEST_RANDOM_SEED} ? $ENV{TEST_RANDOM_SEED} : _get_seed();

# If something else calls srand() we're in trouble
srand $Seed;

# Yes, its not a great seed but it doesn't have to be secure.
sub _get_seed {
    return time ^ ( $$ * $< * $( );
}

sub _display_seed {
    my $tb = shift;

    my $ok = $tb->summary && !( grep !$_, $tb->summary );
    my $msg = "TEST_RANDOM_SEED=$Seed";
    $ok ? $tb->note($msg) : $tb->diag($msg);

    return;
}

END {
    require Test::Builder;
    my $tb = Test::Builder->new;

    if( defined $tb->has_plan or $tb->summary ) {
        _display_seed($tb);
    }
}

1;

__END__

=head1 NAME

Test::Random - Make testing random functions deterministic

=head1 SYNOPSIS

    use Test::Random;

    ... test as normal ...


=head1 DESCRIPTION

This is a testing module to make testing random things a bit more
deterministic.


=head2 Controlling randomness

Its main function is to allow you to repeat a failing test in the same
way it ran before, even if it contained random elements.  Test::Random
will output the seed used by the random number generator.  You can
then use this seed to repeat the last test with exactly the same
random elements.

You can control the random seed used by Test::Random by setting the
C<TEST_RANDOM_SEED> environment variable.  This is handy to make test
runs repeatable.

    TEST_RANDOM_SEED=12345 perl -Ilib t/some_test.t

Test::Random will output the seed used at the end of each test run.
If the test failed it will be visible to the user (ie. on STDERR)
otherwise it will be a TAP comment and only visible if the test is run
verbosely.

If having new data every run is too chaotic for you, you can set
TEST_RANDOM_SEED to something which will remain fixed during a
development session.  Perhaps the PID of your shell or your uid or
the date (20090704, for example).


=head1 EXAMPLE

When you run a test with Test::Random you will see something like this:

    perl some_test.t

    1..3
    ok 1
    ok 2
    ok 3
    # TEST_RANDOM_SEED=20891494266

If you wish to repeat the circumstances of that test, with the same
randomly generated data, you can run it again with the
C<<TEST_RANDOM_SEED>> environment variable set to the given seed.

    TEST_RANDOM_SEED=20891494266 perl some_test.t

    1..3
    ok 1
    ok 2
    ok 3
    # TEST_RANDOM_SEED=20891494266

See your shell and operating system's documentation for details on how
to set environment variables.


=head1 CAVEATS

If something in your code calls srand() all bets are off.


=head1 SEE ALSO

L<Test::RandomResults>, L<Test::Sims>, L<Data::Random>, L<Data::Generate>

=cut
