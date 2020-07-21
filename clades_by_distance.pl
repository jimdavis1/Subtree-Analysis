#! /usr/bin/env perl
use strict;
use gjonewicklib;
use Data::Dumper;
use Getopt::Long;

my $usage = 'clades_by_distance.pl [options] file_of_subtrees
	
	The file of subtrees is generated from: all_subtrees.pl 	
	
	-h help
	-d directory with all dists 
	
	This program lists taxa by grouped by tree distance.
	Tree distance is defined as the longest branch in the subtree.
	The files in the output directory are formatted as:
	 "TipID\tclade number\ttree_distance\n"; 
	
	
	
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

	$n_tips{$trees[$i]} = $size;  # number of tips per subtree
	$max_dists{$dist_max} = 1;    # hash of max distances
	$tree_info->{$trees[$i]}->{MAX} = $dist_max;  #Information for each subtree
	$tree_info->{$trees[$i]}->{TREE} = $subtree; 
	$tree_info->{$trees[$i]}->{TIPS} =  \@tips; 
}

my %all_tips = map{$_, 0}@all_tips;  #hash of all tips in the biggest tree

#for each distinct distance observed for a subtree:

foreach (sort {$a <=> $b} keys %max_dists)  
{
	my $max = $_; 
	my $counter = 0; #<--- don't understand this yet. 
	my %id_clade; 
	
	# sort the trees from smallest to largest as they come in, 
	#this means that the large clades gobble up the small clades. 
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
		}
		$counter ++;
	}
		
	#gather up singleton tips, increment the counter.
	foreach (keys %seen_tips)
	{
		if ($seen_tips{$_} == 0)
		{
			$id_clade{$_} = $counter;
			$counter ++;
		}
	}
	
	
	#reprocess the data for printing.
	my %indv_clades;
	
	foreach (keys %id_clade)
	{
		my $id = $_; 
		my $clade = $id_clade{$_};
		$indv_clades{$clade}++;
	}
	
	my $nclades = keys %indv_clades;

	print STDERR "DIST = $max\tCLADES = $nclades\n"; 
	open (OUT, ">$dir/$nclades.clades");
	
	my $n = 1;
	foreach (sort {$indv_clades{$b} <=> $indv_clades{$a}} keys %indv_clades)
	{
		my $cladeN = $_;
		foreach (keys %id_clade)
		{
			if ($id_clade{$_} == $cladeN)
			{	
				print OUT "$_\t$n\t$max\n";
			}
		}
		$n++;
	}
}
















