#!/bin/bash
cd ~/rds/rds-acf1004-afs-lab-rds/genomes/Mouse-strains

while read name #run tree_grower.R for all strains
do
  cd $name
  
  echo -e "\nProcessing $name\n"
  cp $name.phylip_phyml_tree_$name.txt in-tree.txt
  cp trimal-$name.fa in-fasta.txt #copy files for tree_grower.R
  
  conda activate -R Rscript ../scripts/tree_grower.R $name 
  
  cp outfile.png LTR_phylogeny_$name.png #save outfile as unique name
  
  rm in-tree.txt outfile.png in-fasta.txt #cleanup
  cd ../
done < mouse-strains+hybrids-list.txt
