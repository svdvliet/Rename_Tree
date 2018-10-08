# Shiny App To Rename Tree Files In Newick Format.

This app takes two files:
* Tree file in Newick format
* Renaming file in .csv format

Tree file is read using ape::read.tree()
Package will be installed if not in `installed.packages`

Renaming file must consist of two columns, first one being identical to current names in tree.
Second column will be the new names. Also "rename" the names you want to keep otherwise they will be renamed to `NA`

# Usage:

```r
runGitHub("Rename_Tree", "svdvliet")
```
