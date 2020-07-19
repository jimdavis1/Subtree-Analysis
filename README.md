# Subtree Analysis
This readme will describe the subtree analysis that was performed in "Predicting antimicrobial resistance using conserved genes" by Nguyen et al.  It is intended to aid in the clairity and reproducibility of the analysis. 

The scripts in this repo have one major dependency, it is a perl module for manipulating Newick formated trees that was written by Gary Olsen, and was originally released as part of the code base for the SEED project. The module is called **gjonewicklib.pm**.  The best way to get this module is to download the PATRIC commnad line interface application. I will use another script from that distribution to render the trees, but it is not a prerequeisite. The other modules used by the perl scripts are GitOpt::Long and Data::Dumper, which are pretty standard for perl.

We will start by downloading and installing the PATRIC command line interface Version 1.028 (or earlier) from the PATRIC GitHub repo:  https://github.com/PATRIC3/PATRIC-distribution/releases.  I expect future versions of the PATRIC CLI to contain gjonewiklib, but it's probably safest to get the version we used. The PATRIC team maintains releases of the CLI for Mac, Windows, and Linux systems. 








