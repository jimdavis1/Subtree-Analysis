# Subtree Analysis
  
This readme will describe how the subtrees were built in  *Predicting antimicrobial resistance using conserved genes* by Nguyen et al.  It is intended to aid in the clarity and reproducibility of the analysis.

In order to determine if strain diversity had an influence on the AMR phenotype prediction models, we built phylogenetic trees and normalized the contribution of each genome to each model based on the size of the subtree that it came from, as well as the distribution of susceptibile and resistant phenotypes for the genomes within each subtree. Models were then buit for subtrees defined at varying tree distances.  
  
We will start by downloading this repo. 
  
The scripts in this repo have one major dependency, it is a perl module for manipulating Newick formatted trees that was written by Gary Olsen, and was originally released as part of the code base for the SEED project. The module is called ```gjonewicklib.pm```.  The best way to get this module is to download the PATRIC command line interface application. I will use another script from that distribution to render the trees, but it is not a prerequisite. The other modules used by the perl scripts are GitOpt::Long and Data::Dumper, which are pretty standard for perl.
  
We will download and install the PATRIC command line interface Version 1.025 (or earlier) from the PATRIC GitHub repo:  https://github.com/PATRIC3/PATRIC-distribution/releases.  If you download the latest version, the tree analysis will still work, but it is missing a module for my favorite tree renderer, ```svr_tree_to_html```, which was written by Fangfang Xia and Gary Olsen. I am expecting this to get fixed in the 1.03 or later release. 

If you are on a mac, simply drag the icon into your applications folder:
![PATRIC](https://github.com/jimdavis1/Subtree-Analysis/blob/0b00e64ae8ae3abd9766c47a26697f1258682ffe/patric.png)

It takes 1.38 GB of space.  On a mac, you may need to control-click to open the application, and then allow access to the terminal.  If you are working from a linux or windows machine, you can download an appropriate distribution from the PATRIC GitHub. 

In the mac installation, the library is located in:
```Applications/PATRIC.app/deployment/lib/```

Now the easiest way to proceed is by launching the PATRIC.app.  This will initiate a new terminal window with all of the dependencies in the current path.  If you dislike this option, or you are working on a linux or windows device, you will need to add the contents of the PATRIC app to your path. If you are using bash, should be able to do this by typing:
  
```source /Applications/PATRIC.app/user-env.sh```
  
Note that the location of the PATRIC.app may differ depending on your operating system or where you have decided to install it. 

The gjonewicklib perl module is located in ```deployment/lib/``` if you want to view it or work with it separately. 

Go to your repo directory and let's quickly see if you got the download and path right by running:
  
```perl clades_by_distance.pl -h```

If you have ```gjonewicklib.pm``` in your path, you will see the help menu for that script and not a warning.
Typing:
  
```svr_tree_to_html -h```
  
Should also show a help menu. 

This GitHub repo contains four Newick-formatted phylogenetic trees: ```Kleb.nwk, Mtb.nwk, Sal.nwk, and Staph.nwk```, that were built for the paper for *Klebsiella pneumoniae*, *Mycobacterium tuberculosis*, *Salmonella enterica*, and *Staphylococcus aureus* respectively.  These trees were built from concatenated alignments of 100 core conserved genes that are held in common across each species.  Trees were generated using FastTree using the generalized time-reversible model.

To demonstrate what was done, we will generate a toy example.  We will generate a subtree using a small set of genes from the original Salmonella tree.  Copy and paste the following perl one-liner into the command line:  

```perl -e 'use gjonewicklib; $nwk = join( "", <> ); $tree = gjonewicklib::parse_newick_tree_str( $nwk ); @tips = &gjonewicklib::newick_tip_list($tree);  $newtree = newick_subtree( $tree, @tips[0..25] ); &gjonewicklib::writeNewickTree($newtree); '<Sal.nwk >Sal.example.nwk```

This creates a Newick formatted subtree with 26 tips.  Our little script first reads the tree from STDIN, generates the appropriate data structure for the tree, makes an array of all of the tips in the tree,  generates a subtree for tips 0-25, and finally  renders the subtree in Newick format. 

The file Sal.example.nwk looks like this:
  
```(( ( ( ( SRR1914397: 0.000550, ( ( SRR3295889: 0.000000, SRR2583949: 0.000000): 0.000550, SRR2583962: 0.000550) 0.000: 0.000550) 0.943: 0.000550, ( SRR2993804: 0.000550, ( SRR3210384: 0.000550, SRR2981109: 0.001100) 0.736: 0.001100) 0.342: 0.000550) 1.000: 0.004590, ( SRR1534824: 0.000550, ( ( ( SRR1200749: 0.000550, SRR3057229: 0.000550) 0.456: 0.000550, SRR1631196: 0.001100) 0.443: 0.000550, ( ( ( ( ( SRR1202996: 0.001100, SRR3664861: 0.000550) 0.000: 0.001100, SRR2638070: 0.000550) 0.000: 0.000550, ( ( SRR3146664: 0.000550, SRR3932918: 0.000550) 0.000: 0.000550, ( SRR3933056: 0.000000, SRR3664614: 0.000000, SRR3664684: 0.000000, SRR3665234: 0.000000): 0.000550) 0.000: 0.000550) 0.000: 0.000550, SRR2566885: 0.002200) 0.000: 0.000550, SRR2566981: 0.001650) 0.000: 0.001100) 0.835: 0.001100) 1.000: 0.003840) 1.000: 0.001270, ( SRR2637879: 0.000550, ( SRR3664639: 0.000550, ( SRR3295726: 0.000550, SRR3056905: 0.000550) 0.000: 0.000550) 0.000: 0.001100) 0.832: 0.006220) 0.486;```
  
The first program in this repo divides a tree file into all possible subtrees.   This is done simply by searching for open and closed parentheses in the Newick file.   The program does not consider each individual tip to be a subtree.  It also lists the full tree as the final "subtree" on the last line of the file.  I should point out that this program has not been tested on trees with internal node labels, and it will probably fail in cases where tips contain parentheses.  Because of this, the script is only intended to be used in this context. 

typing:
  
```perl all_subtrees.pl <Sal.example.nwk >Sal.example.subtrees```

Yields the file with all of the possible subtrees.  
  
The next program reads the file of all subtrees and creates a directory that lists each tip as a member of a subtree or clade. Type:

```perl clades_by_distance.pl -d Sal.example.dir <Sal.example.subtrees```

The standard error looks like this:
```
DIST = 0	CLADES = 22
DIST = 0.00055	CLADES = 18
DIST = 0.0011	CLADES = 12
DIST = 0.0022	CLADES = 9
DIST = 0.00275	CLADES = 7
DIST = 0.0033	CLADES = 6
DIST = 0.00385	CLADES = 5
DIST = 0.00495	CLADES = 4
DIST = 0.00605	CLADES = 3
DIST = 0.00989	CLADES = 2
DIST = 0.01116	CLADES = 1

```
The program works by computing the longest tip distance for each subtree.  Then for each of the distances, it finds the largest subtrees that are less than or equal to the given tip distance.  A file is made for each set of subtrees defined at each distance.  In the standard error, "DIST" is each of the incremented tree distances that were tested. The "CLADES" are the number of subtrees that were found at each distance.  A single tip will form its own clade when it is too distant to be part of a subtree containing other tips.  Note that when the distance is small, there are many clades, and as distance increases, the threshold becomes more inclusive, and there are fewer clades.

The ```-d``` flag, which is required, is the name of a directory containing the clades defined at each distance.  It is formatted as "TipID\tCladeNumber\tDistance\n".  So, if type:

```cat Sal.example.dir/18.clades```
  
You will see:
 
```
SRR3933056	1	0.00055
SRR3665234	1	0.00055
SRR3664614	1	0.00055
SRR3664684	1	0.00055
SRR3295889	2	0.00055
SRR2583962	2	0.00055
SRR2583949	2	0.00055
SRR1200749	3	0.00055
SRR3057229	3	0.00055
SRR3056905	4	0.00055
SRR3295726	4	0.00055
SRR3932918	5	0.00055
SRR3146664	5	0.00055
SRR1202996	6	0.00055
SRR3664861	7	0.00055
SRR3210384	8	0.00055
SRR2981109	9	0.00055
SRR2993804	10	0.00055
SRR2566981	11	0.00055
SRR2637879	12	0.00055
SRR2638070	13	0.00055
SRR1631196	14	0.00055
SRR1914397	15	0.00055
SRR1534824	16	0.00055
SRR3664639	17	0.00055
SRR2566885	18	0.00055
```

Where each tip is assigned to one of 18 possible clades. 

In order to illustrate the behavior, we will use a script from the PATRIC.app to color and render each subtree so that we can see what happened.  Type:  
  
```
svr_tree_to_html -raw -c Sal.example.dir/2.clades <Sal.example.nwk >Sal.example.2.clades.html
```

The output can be viewed by opening it in a browser window. The ```-c``` option tells the program to color the  tree based on the clades defined in ```Sal.example.dir/2.clades```.  The ```-raw``` option tells the program not to collapse zero-length branches.

Here is what it looks like, with 2 clades defined at a distance of 0.00989.

![2.clades](https://github.com/jimdavis1/Subtree-Analysis/blob/master/2.clades.png) 

  
**Four clades**, ```svr_tree_to_html -raw -c Sal.example.dir/4.clades <Sal.example.nwk >Sal.example.4.clades.html``` looks like this:

![4.clades](https://github.com/jimdavis1/Subtree-Analysis/blob/master/4.clades.png)
  
  
**Six clades:** ```svr_tree_to_html -raw -c Sal.example.dir/6.clades <Sal.example.nwk >Sal.example.6.clades.html```
  
![6.clades](https://github.com/jimdavis1/Subtree-Analysis/blob/master/6.clades.png)

  
**Nine clades:** ```svr_tree_to_html -raw -c Sal.example.dir/9.clades <Sal.example.nwk >Sal.example.9.clades.html```
![9.clades](https://github.com/jimdavis1/Subtree-Analysis/blob/master/9.clades.png)

  
**Twelve clades**, ```svr_tree_to_html -raw -nc 12 -c Sal.example.dir/12.clades <Sal.example.nwk >Sal.example.12.clades.html``` (here we have to tell the program to start recycling colors with the ```-nc``` option).
  
![12.clades](https://github.com/jimdavis1/Subtree-Analysis/blob/master/12.clades.png)

  
**Eighteen clades:**```svr_tree_to_html -raw -nc 18 -c Sal.example.dir/18.clades <Sal.example.nwk >Sal.example.18.clades.html``` 
  
![18.clades](https://github.com/jimdavis1/Subtree-Analysis/blob/master/18.clades.png)


Note that as the distance decreases, the number of clades goes up, and the size of each clade goes down. Also, the number of clades cannot be forced. For example, there was no distance that yielded 8 clades.  
  
I should also point out that a subtree could be defined a several of different ways.  For instance, you could measure all tip-to-tip distances instead of the longest branch length, or you could measure the average distance against one tip.  We chose the longest branch length because it was simple and easy to compute.  It is possible that there could be conditions where this has undesirable behavior, but we have found that it works works reasonably well.

To get the set of clades used in our paper, simply repeat the analysis using the full-sized trees supplied in this repo. 




