#!/bin/bash

name=$1

cd $name #changing directories for calling this function in a loop

#sequence alignment
mafft all-IAP-$name.fa > mafft-$name.fa 

#trimming for phyml
trimal -in mafft-$name.fa -out trimal-$name.fa -automated1 
seqret -sequence trimal-$name.fa -outseq $name.phylip -osformat phylip

#clustering
phyml -i $name.phylip --run_id $name --quiet --no_memory_check > temp-$name.out 

#Generating list IDs in order of the tree
awk -F "," -v OFS="\n" '{$1 = $1 } {print $0}' $name.phylip_phyml_tree_$name.txt |  awk -F ":" '{print $1}' | awk -F "(" '{print $NF}' > $name-phylip_phyml_tree-list.txt 

cd ../
