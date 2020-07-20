# Subtree Analysis
This readme will describe the subtree analysis that was performed in *Predicting antimicrobial resistance using conserved genes* by Nguyen et al.  It is intended to aid in the clarity and reproducibility of the analysis. 

We will start by downloading this repo. 

The scripts in this repo have one major dependency, it is a perl module for manipulating Newick formatted trees that was written by Gary Olsen, and was originally released as part of the code base for the SEED project. The module is called ```gjonewicklib.pm```.  The best way to get this module is to download the PATRIC command line interface application. I will use another script from that distribution to render the trees, but it is not a prerequisite. The other modules used by the perl scripts are GitOpt::Long and Data::Dumper, which are pretty standard for perl.

We will start by downloading and installing the PATRIC command line interface Version 1.025 (or earlier) from the PATRIC GitHub repo:  https://github.com/PATRIC3/PATRIC-distribution/releases.  If you download the latest version, the tree analysis will still work, but it is missing a module for my favorite tree renderer, ```svr_tree_to_html```, which was written by Fangfang Xia and Gary Olsen. I am expecting this to get fixed in the 1.03 or later release. 

After downloading, 1.025, drag it into your applications folder:
![PATRIC](https://raw.githubusercontent.com/jimdavis1/Subtree-Analysis/b3cde940eb2b63f621ec06d539690e47b176ad5d/Patric.png)

It takes 1.38 GB of space.  On a mac, you may need to control-click to open the application, and then allow access to the terminal.

The library is located in:
```Applications/PATRIC.app/deployment/lib/```

Now the easiest way to proceed is by launching the PATRIC.app.  This will initiate a new terminal window with all of the dependencies in the current path.  If you dislike this option, or you are working on a Linux or windows device, you will need to add the the contents of the PATRIC app to your path. If you are using bash, should be able to do this by typing:  
  
```source /Applications/PATRIC.app/user-env.sh```

Go to your repo directory and let's quickly see if we got the download and path right by running:
  
```perl clades_by_distance.pl -h```

If you have ```gjonewicklib.pm``` in your path, you will see the help menu for that script and not a warning.
Typing:
  
```svr_tree_to_html -h```
  
Should also show a help menu. 

This GitHub repo contains four Newick-formatted phylogenetic trees: ```Kleb.nwk, Mtb.nwk, Sal.nwk, and Staph.nwk```, which are the phylogenetic trees that were built for the paper for *Klebsiella pneumoniae*, *Mycobacterium tuberculosis*, *Salmonella enterica*, and *Staphylococcus aureus* respectively.  These trees were built from concatenated alignments of 100 core conserved genes that are held in common across each species.  Nucleotide alignments were rendered using FastTree using the generalized time-reversible model.














