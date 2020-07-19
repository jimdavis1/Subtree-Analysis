# Subtree Analysis
This readme will describe the subtree analysis that was performed in "Predicting antimicrobial resistance using conserved genes" by Nguyen et al.  It is intended to aid in the clarity and reproducibility of the analysis. 

The scripts in this repo have one major dependency, it is a perl module for manipulating Newick formatted trees that was written by Gary Olsen, and was originally released as part of the code base for the SEED project. The module is called ```gjonewicklib.pm```.  The best way to get this module is to download the PATRIC command line interface application. I will use another script from that distribution to render the trees, but it is not a prerequisite. The other modules used by the perl scripts are GitOpt::Long and Data::Dumper, which are pretty standard for perl.

We will start by downloading and installing the PATRIC command line interface Version 1.028 (or earlier) from the PATRIC GitHub repo:  https://github.com/PATRIC3/PATRIC-distribution/releases.  I expect future versions of the PATRIC CLI to contain gjonewicklib, but it's probably safest to get the version we used. The PATRIC team maintains releases of the CLI for Mac, Windows, and Linux systems. The version of gjonewicklib.pm is open source and can be redistributed and modified, license information exists at the top of the file. 

After downloading, 1.028, drag it into your applications folder:
![PATRIC](https://raw.githubusercontent.com/jimdavis1/Subtree-Analysis/b3cde940eb2b63f621ec06d539690e47b176ad5d/Patric.png)

It takes 1.54 GB of space.  On a mac, you may need to control-click to open the application, and then allow accesst to the terminal.

The library is located in:
```Applications/PATRIC.app/deployment/lib/```









