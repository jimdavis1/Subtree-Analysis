#! /usr/bin/env perl
use strict;
use gjonewicklib;
use Data::Dumper;
use Getopt::Long;

my $usage = 'clades_by_distance.pl [options] file_of_subtrees
	
	The file of subtrees is generated from: all_subtrees.pl .	
	-h help
	-d directory with all dists 
	
	Note that there is no continuity in clade numbering from one distance to the next.
';

my $steps = 100;
my ($help, $dir);
my $opts = GetOptions('h'   => \$help, 
                      'd=s' => \$dir);

if ($help){die "$usage\n"}
unless ($dir){ die "must declare an output directory\n\n$usage";}
mkdir $dir;

my $file = shift @ARGV;
my @trees = read_newick_trees( $file );

my $tree_info;
my %n_tips; 
my %max_dists; 
my @all_tips; 
my $biggest = 0; 
for my $i (0..$#trees)
{
	my $subtree = $trees[$i];
	my ($most, $dist_max ) = &gjonewicklib::newick_most_distant_tip_name( $subtree );
		
	my @tips = &gjonewicklib::newick_tip_list( $subtree );	
	my $size = scalar @tips;
	if ($size > $biggest)  # get a tip list for all of the tips of the subtree. 
	{
		@all_tips = @tips; 
		$biggest = $size;
	}
	
	$n_tips{$trees[$i]} = $size;
	$max_dists{$dist_max} = 1; 
	$tree_info->{$trees[$i]}->{MAX} = $dist_max;
	$tree_info->{$trees[$i]}->{TREE} = $subtree; 
	$tree_info->{$trees[$i]}->{TIPS} =  \@tips; 
}


my %all_tips = map{$_, 0}@all_tips;

# get max dist increments smallest to largest 
foreach (sort {$a <=> $b} keys %max_dists)
{
	my $max = $_; 
	my $counter = 0;  		
	my %id_clade; 
	
	# sort the trees from smallest to largest as they come in, 
	#this means that the large lades gobble up the small clades. 
	my %seen_tips = %all_tips;
	foreach (sort {$n_tips{$a} <=> $n_tips{$b}} keys %n_tips)
	{
		
		my $subtree = $tree_info->{$_}->{TREE}; 
		my $treedist = $tree_info->{$_}->{MAX}; 
		my $tipR = $tree_info->{$_}->{TIPS};
		my @tips = @$tipR; 
	
		if ($treedist le $max)
		{			 
			foreach (@tips)
			{
				$id_clade{$_} = $counter;
				$seen_tips{$_} ++; 
			}
			$counter ++; 
		}
	}
	
	#Get info before adding back the singleton tips 
	my $ntips = keys %id_clade;
	my %rev = reverse %id_clade;
	my @vals = keys %rev;
	my $nclades = scalar @vals; 

	
	#gather up singleton tips.
	foreach (keys %seen_tips)
	{
		if ($seen_tips{$_} == 0)
		{
			$id_clade{$_} = $counter;
			$counter ++;
		}
	}
	

	print STDERR "$max\t$nclades\t$ntips\n"; 
	open (OUT, ">$dir/$nclades.clades");
	foreach (sort {$id_clade{$a} <=> $id_clade{$b}} keys %id_clade)
	{
		print OUT "$_\t$id_clade{$_}\n";
	}

}
























