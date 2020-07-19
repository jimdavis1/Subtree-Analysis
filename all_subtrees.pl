#! /usr/bin/perl 
use strict;
use Data::Dumper;
use Getopt::Long;


my $usage = 'usage all_subtrees.pl <tree.nwk> file_of_subtrees

	This program reads a Newick-formatted tree file from STDIN and returns all of the 
	possible subtrees.  One subtree is printed per line.  Tips are not included 
	as subtrees.
	
	This script works by breaking the Newick file into all possible characters 
	and counting the correspoinding "(" and ")" symbols. 
	
	There are probably conditions where it will not work.  
	It has not been tested in trees with internal node labels.  
	You probably want to avoid using parentheses in your tip or node labels.  

';

my ($help);
my $opts = GetOptions('h'   => \$help);

if ($help){die "$usage\n"}

my $tree;
while (<>)
{
	chomp;
	if ($_)
	{
		$tree = $_;
	}
}

my @tree = split ('', $tree);

my %forward;
my %reverse;
my $count = 0;
for my $i (0..$#tree){
	if ($tree[$i] =~ /\(/){
		$count ++;
		$forward{$i} = $count;
	}
	elsif($tree[$i] =~ /\)/){
		$count --;
		$reverse{$i} = $count;
	}
}

my @all_nodes;
my $previous = 0;

foreach (sort { $a <=> $b } keys(%reverse) )
{
	my $rev_position = $_;
	my $current = $reverse{$_};
	my @poss = ();
	foreach (keys %forward)
	{
		if (($forward{$_} == ($current + 1)) && ($rev_position > $_))
		{ 
			push @poss, $_;
		}
	}
		my @sort_poss = sort {$a <=> $b} @poss;
		my $answer  = pop @sort_poss;
		my $node = join ('', @tree[$answer..$rev_position]);
		print "$node;\n";
}





















