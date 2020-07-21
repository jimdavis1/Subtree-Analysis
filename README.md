# Subtree Analysis
This readme will describe the subtree analysis that was performed in *Predicting antimicrobial resistance using conserved genes* by Nguyen et al.  It is intended to aid in the clarity and reproducibility of the analysis. 

We will start by downloading this repo. 

The scripts in this repo have one major dependency, it is a perl module for manipulating Newick formatted trees that was written by Gary Olsen, and was originally released as part of the code base for the SEED project. The module is called ```gjonewicklib.pm```.  The best way to get this module is to download the PATRIC command line interface application. I will use another script from that distribution to render the trees, but it is not a prerequisite. The other modules used by the perl scripts are GitOpt::Long and Data::Dumper, which are pretty standard for perl.

We will start by downloading and installing the PATRIC command line interface Version 1.025 (or earlier) from the PATRIC GitHub repo:  https://github.com/PATRIC3/PATRIC-distribution/releases.  If you download the latest version, the tree analysis will still work, but it is missing a module for my favorite tree renderer, ```svr_tree_to_html```, which was written by Fangfang Xia and Gary Olsen. I am expecting this to get fixed in the 1.03 or later release. 

If you are on a mac, simply drag the icon into your applications folder:
![PATRIC](https://github.com/jimdavis1/Subtree-Analysis/blob/0b00e64ae8ae3abd9766c47a26697f1258682ffe/patric.png)

It takes 1.38 GB of space.  On a mac, you may need to control-click to open the application, and then allow access to the terminal.  If you are working from a linux or windows machine, you can download an appropriate distribution from the PATRIC GitHub. 

In the mac installation, the library is located in:
```Applications/PATRIC.app/deployment/lib/```

Now the easiest way to proceed is by launching the PATRIC.app.  This will initiate a new terminal window with all of the dependencies in the current path.  If you dislike this option, or you are working on a linux or windows device, you will need to add the the contents of the PATRIC app to your path. If you are using bash, should be able to do this by typing:
  
```source /Applications/PATRIC.app/user-env.sh```

The gjonewicklib perl module is located in ```/deployment/lib/``` if you want to view it or work with it separately. 

Go to your repo directory and let's quickly see if we got the download and path right by running:
  
```perl clades_by_distance.pl -h```

If you have ```gjonewicklib.pm``` in your path, you will see the help menu for that script and not a warning.
Typing:
  
```svr_tree_to_html -h```
  
Should also show a help menu. 

This GitHub repo contains four Newick-formatted phylogenetic trees: ```Kleb.nwk, Mtb.nwk, Sal.nwk, and Staph.nwk```, which are the phylogenetic trees that were built for the paper for *Klebsiella pneumoniae*, *Mycobacterium tuberculosis*, *Salmonella enterica*, and *Staphylococcus aureus* respectively.  These trees were built from concatenated alignments of 100 core conserved genes that are held in common across each species.  Nucleotide alignments were rendered using FastTree using the generalized time-reversible model.

To demonstrate what was done, we will generate a toy example.  We will generate a subtree using a small set of genes from the original Salmonella tree.  Copy and paste the following perl one-liner into the command line.  

```perl -e 'use strict; use gjonewicklib; my $nwk = join( "", <> ); my $tree = gjonewicklib::parse_newick_tree_str( $nwk ); my @tips = &gjonewicklib::newick_tip_list($tree); my @subset = @tips[0..25]; my $newtree = newick_subtree( $tree,  @subset ); &gjonewicklib::writeNewickTree($newtree); '<Sal.nwk >Sal.example.nwk
`` >Sal.example.2.clades.html```

This creates a newick formatted subtree with 26 tips.  The file Sal.example.nwk looks like this:
  
```( ( ( ( SRR1914397: 0.000550, ( ( SRR3295889: 0.000000, SRR2583949: 0.000000): 0.000550, SRR2583962: 0.000550) 0.000: 0.000550) 0.943: 0.000550, ( SRR2993804: 0.000550, ( SRR3210384: 0.000550, SRR2981109: 0.001100) 0.736: 0.001100) 0.342: 0.000550) 1.000: 0.004590, ( SRR1534824: 0.000550, ( ( ( SRR1200749: 0.000550, SRR3057229: 0.000550) 0.456: 0.000550, SRR1631196: 0.001100) 0.443: 0.000550, ( ( ( ( ( SRR1202996: 0.001100, SRR3664861: 0.000550) 0.000: 0.001100, SRR2638070: 0.000550) 0.000: 0.000550, ( ( SRR3146664: 0.000550, SRR3932918: 0.000550) 0.000: 0.000550, ( SRR3933056: 0.000000, SRR3664614: 0.000000, SRR3664684: 0.000000, SRR3665234: 0.000000): 0.000550) 0.000: 0.000550) 0.000: 0.000550, SRR2566885: 0.002200) 0.000: 0.000550, SRR2566981: 0.001650) 0.000: 0.001100) 0.835: 0.001100) 1.000: 0.003840) 1.000: 0.001270, ( SRR2637879: 0.000550, ( SRR3664639: 0.000550, ( SRR3295726: 0.000550, SRR3056905: 0.000550) 0.000: 0.000550) 0.000: 0.001100) 0.832: 0.006220) 0.486;```
  
The first program in this repo divides a tree file into all possible subtrees (including the whole tree, but excluding tips).  This is done simply by searching for open and closed parentheses, and it has not be tested on trees with node labels, so it should probably only be used in this context. 

typing 
```perl all_subtrees.pl <Sal.example.nwk >Sal.example.subtrees```

Yeilds a file with all of the possible subtrees.  
Here are they are:
  
```
( SRR3295889: 0.000000, SRR2583949: 0.000000);
( ( SRR3295889: 0.000000, SRR2583949: 0.000000): 0.000550, SRR2583962: 0.000550);
( SRR1914397: 0.000550, ( ( SRR3295889: 0.000000, SRR2583949: 0.000000): 0.000550, SRR2583962: 0.000550) 0.000: 0.000550);
( SRR3210384: 0.000550, SRR2981109: 0.001100);
( SRR2993804: 0.000550, ( SRR3210384: 0.000550, SRR2981109: 0.001100) 0.736: 0.001100);
( ( SRR1914397: 0.000550, ( ( SRR3295889: 0.000000, SRR2583949: 0.000000): 0.000550, SRR2583962: 0.000550) 0.000: 0.000550) 0.943: 0.000550, ( SRR2993804: 0.000550, ( SRR3210384: 0.000550, SRR2981109: 0.001100) 0.736: 0.001100) 0.342: 0.000550);
( SRR1200749: 0.000550, SRR3057229: 0.000550);
( ( SRR1200749: 0.000550, SRR3057229: 0.000550) 0.456: 0.000550, SRR1631196: 0.001100);
( SRR1202996: 0.001100, SRR3664861: 0.000550);
( ( SRR1202996: 0.001100, SRR3664861: 0.000550) 0.000: 0.001100, SRR2638070: 0.000550);
( SRR3146664: 0.000550, SRR3932918: 0.000550);
( SRR3933056: 0.000000, SRR3664614: 0.000000, SRR3664684: 0.000000, SRR3665234: 0.000000);
( ( SRR3146664: 0.000550, SRR3932918: 0.000550) 0.000: 0.000550, ( SRR3933056: 0.000000, SRR3664614: 0.000000, SRR3664684: 0.000000, SRR3665234: 0.000000): 0.000550);
( ( ( SRR1202996: 0.001100, SRR3664861: 0.000550) 0.000: 0.001100, SRR2638070: 0.000550) 0.000: 0.000550, ( ( SRR3146664: 0.000550, SRR3932918: 0.000550) 0.000: 0.000550, ( SRR3933056: 0.000000, SRR3664614: 0.000000, SRR3664684: 0.000000, SRR3665234: 0.000000): 0.000550) 0.000: 0.000550);
( ( ( ( SRR1202996: 0.001100, SRR3664861: 0.000550) 0.000: 0.001100, SRR2638070: 0.000550) 0.000: 0.000550, ( ( SRR3146664: 0.000550, SRR3932918: 0.000550) 0.000: 0.000550, ( SRR3933056: 0.000000, SRR3664614: 0.000000, SRR3664684: 0.000000, SRR3665234: 0.000000): 0.000550) 0.000: 0.000550) 0.000: 0.000550, SRR2566885: 0.002200);
( ( ( ( ( SRR1202996: 0.001100, SRR3664861: 0.000550) 0.000: 0.001100, SRR2638070: 0.000550) 0.000: 0.000550, ( ( SRR3146664: 0.000550, SRR3932918: 0.000550) 0.000: 0.000550, ( SRR3933056: 0.000000, SRR3664614: 0.000000, SRR3664684: 0.000000, SRR3665234: 0.000000): 0.000550) 0.000: 0.000550) 0.000: 0.000550, SRR2566885: 0.002200) 0.000: 0.000550, SRR2566981: 0.001650);
( ( ( SRR1200749: 0.000550, SRR3057229: 0.000550) 0.456: 0.000550, SRR1631196: 0.001100) 0.443: 0.000550, ( ( ( ( ( SRR1202996: 0.001100, SRR3664861: 0.000550) 0.000: 0.001100, SRR2638070: 0.000550) 0.000: 0.000550, ( ( SRR3146664: 0.000550, SRR3932918: 0.000550) 0.000: 0.000550, ( SRR3933056: 0.000000, SRR3664614: 0.000000, SRR3664684: 0.000000, SRR3665234: 0.000000): 0.000550) 0.000: 0.000550) 0.000: 0.000550, SRR2566885: 0.002200) 0.000: 0.000550, SRR2566981: 0.001650) 0.000: 0.001100);
( SRR1534824: 0.000550, ( ( ( SRR1200749: 0.000550, SRR3057229: 0.000550) 0.456: 0.000550, SRR1631196: 0.001100) 0.443: 0.000550, ( ( ( ( ( SRR1202996: 0.001100, SRR3664861: 0.000550) 0.000: 0.001100, SRR2638070: 0.000550) 0.000: 0.000550, ( ( SRR3146664: 0.000550, SRR3932918: 0.000550) 0.000: 0.000550, ( SRR3933056: 0.000000, SRR3664614: 0.000000, SRR3664684: 0.000000, SRR3665234: 0.000000): 0.000550) 0.000: 0.000550) 0.000: 0.000550, SRR2566885: 0.002200) 0.000: 0.000550, SRR2566981: 0.001650) 0.000: 0.001100) 0.835: 0.001100);
( ( ( SRR1914397: 0.000550, ( ( SRR3295889: 0.000000, SRR2583949: 0.000000): 0.000550, SRR2583962: 0.000550) 0.000: 0.000550) 0.943: 0.000550, ( SRR2993804: 0.000550, ( SRR3210384: 0.000550, SRR2981109: 0.001100) 0.736: 0.001100) 0.342: 0.000550) 1.000: 0.004590, ( SRR1534824: 0.000550, ( ( ( SRR1200749: 0.000550, SRR3057229: 0.000550) 0.456: 0.000550, SRR1631196: 0.001100) 0.443: 0.000550, ( ( ( ( ( SRR1202996: 0.001100, SRR3664861: 0.000550) 0.000: 0.001100, SRR2638070: 0.000550) 0.000: 0.000550, ( ( SRR3146664: 0.000550, SRR3932918: 0.000550) 0.000: 0.000550, ( SRR3933056: 0.000000, SRR3664614: 0.000000, SRR3664684: 0.000000, SRR3665234: 0.000000): 0.000550) 0.000: 0.000550) 0.000: 0.000550, SRR2566885: 0.002200) 0.000: 0.000550, SRR2566981: 0.001650) 0.000: 0.001100) 0.835: 0.001100) 1.000: 0.003840);
( SRR3295726: 0.000550, SRR3056905: 0.000550);
( SRR3664639: 0.000550, ( SRR3295726: 0.000550, SRR3056905: 0.000550) 0.000: 0.000550);
( SRR2637879: 0.000550, ( SRR3664639: 0.000550, ( SRR3295726: 0.000550, SRR3056905: 0.000550) 0.000: 0.000550) 0.000: 0.001100);
( ( ( ( SRR1914397: 0.000550, ( ( SRR3295889: 0.000000, SRR2583949: 0.000000): 0.000550, SRR2583962: 0.000550) 0.000: 0.000550) 0.943: 0.000550, ( SRR2993804: 0.000550, ( SRR3210384: 0.000550, SRR2981109: 0.001100) 0.736: 0.001100) 0.342: 0.000550) 1.000: 0.004590, ( SRR1534824: 0.000550, ( ( ( SRR1200749: 0.000550, SRR3057229: 0.000550) 0.456: 0.000550, SRR1631196: 0.001100) 0.443: 0.000550, ( ( ( ( ( SRR1202996: 0.001100, SRR3664861: 0.000550) 0.000: 0.001100, SRR2638070: 0.000550) 0.000: 0.000550, ( ( SRR3146664: 0.000550, SRR3932918: 0.000550) 0.000: 0.000550, ( SRR3933056: 0.000000, SRR3664614: 0.000000, SRR3664684: 0.000000, SRR3665234: 0.000000): 0.000550) 0.000: 0.000550) 0.000: 0.000550, SRR2566885: 0.002200) 0.000: 0.000550, SRR2566981: 0.001650) 0.000: 0.001100) 0.835: 0.001100) 1.000: 0.003840) 1.000: 0.001270, ( SRR2637879: 0.000550, ( SRR3664639: 0.000550, ( SRR3295726: 0.000550, SRR3056905: 0.000550) 0.000: 0.000550) 0.000: 0.001100) 0.832: 0.006220);
```
  
The next program reads this file of all subtrees and creates a directory that lists each tip as a member of a subtree.  Subtrees are defined using a distance threshold.  The "distance" of each subtree is defined as the maximium tip distance, and the most inclusive subtree that can be built at a given distance is used. The tips, and their corresponding  "clade" or subtree is returned in the directory.  To demonstrate this, we will run:
  
```perl clades_by_distance.pl -d Sal.example.dir <Sal.example.subtrees```

This generates a directory called, "Sal.example.dir", and inside the directory there are six files.  Each file contains a tab-delimited list of tips and the clade number.  *Note that the clade number is arbitrary.  It only exists as a label defnining which tips belong to which clades.*  The files are named 1.clades through 6.clades.  1.clades is the most inclusive.  It is the set of clades for the largest distance threshold.  In other words, 1.clades is defining a subtree as the full original tree.  With each succesive file the distance gets smaller and the number of possible clades becomes larger. The program will not split zero-length branches. 

We will use a script from the PATRIC.app to color and render each subtree.  
  
```svr_tree_to_html -raw -c Sal.example.dir/2.clades <Sal.example.nwk >Sal.example.2.clades.html```

The output can be viewed by opening it in a browser window. I will do this for each example, changing the -c option to color the original example tree based on the clades defined in ```Sal.example.dir```.




