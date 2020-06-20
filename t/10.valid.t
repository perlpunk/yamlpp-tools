#!/usr/bin/perl
use strict;
use warnings;
use 5.010;
use Test::More;
use FindBin '$Bin';
use autodie qw/ open opendir /;
use YAML::PP;
use YAML::PP::Highlight;

my $testsuite = "$Bin/../test-suite-data";
my $script = "$Bin/../bin/yamlpp-schema-convert";

my @ids;
opendir (my $dh, $testsuite);
while (my $item = readdir $dh) {
    next unless $item =~ m/^[0-9A-Z]{4}$/;
    next unless -d "$testsuite/$item";
    push @ids, $item;
}
closedir $dh;
@ids = sort @ids;
diag scalar @ids;
@ids = @ids[0..319];
my %skip = map { $_ => 1 } qw(
    2AUY
    2LFX
    33X3
    6LVF
    74H7
    BEC7
    F2C7
    L94M
    S4JQ

    4FJ6
    6BFJ
    87E4
    8CWC
    8UDB
    9MMW
    CN3R
    CT4Q
    G5U8
    KZN9
    L9U5
    LQZ7
    LX3P
    Q9WF
    QF4Y
);
my %except = map { $_ => 1 } qw(
    C4HZ
    RZP5
    U9NS
    UGM3
    XW4D
);
#warn __PACKAGE__.':'.__LINE__.$".Data::Dumper->Dump([\%skip], ['skip']);
@ids = grep { not $skip{ $_ } and not $except{ $_ } } @ids;
#warn __PACKAGE__.':'.__LINE__.$".Data::Dumper->Dump([\@ids], ['ids']);


for my $id (@ids) {
    my $path = "$testsuite/$id";
    my $fh;
    open $fh, '<', "$path/in.yaml";
    my $inyaml = do { local $/; <$fh> };
    close $fh;
    next if -f "$path/error";
#    diag $id;
    my $cmd = qq{$^X $script $path/in.yaml};
#    diag $cmd;
    my $outyaml = qx{$cmd};
    unless (is($outyaml, $inyaml, "($id) Converted YAML like expected") ) {
        note("$path/in.yaml");
        my ($error, $tokens, $h);
        ($error, $tokens) = YAML::PP::Parser->yaml_to_tokens( string => $inyaml );
        $h = YAML::PP::Highlight->ansicolored($tokens);
        diag "-------- in.yaml";
        diag $h;
        ($error, $tokens) = YAML::PP::Parser->yaml_to_tokens( string => $outyaml );
        $h = YAML::PP::Highlight->ansicolored($tokens);
        diag "-------- output";
        diag $h;
    }

}

done_testing;
