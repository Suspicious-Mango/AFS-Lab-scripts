#directory set by fasta_to_tree pipeline (output to folder with LTR1s-$name.fa)

#!/bin/bash
name=$1

#sequence alignment
#mafft whole-IAPLTR1-$name.fa > mafft-whole-IAPLTR1-$name.fa 

#trimming sequences for phyml
#trimal -in mafft-whole-IAPLTR1-$name.fa -out trimal-whole-IAPLTR1-$name.fa -automated1 
#seqret -sequence trimal-whole-IAPLTR1-$name.fa -outseq whole-IAPLTR1-$name.phylip -osformat phylip

#Clustering
phyml -i whole-IAPLTR1-$name.phylip --run_id $name --quiet --no_memory_check > temp-whole-IAPLTR1-$name.out

#Generating list of IDs in order of how they appear on the tree
awk -F "," -v OFS="\n" '{$1 = $1 } {print $0}' whole-IAPLTR1-$name.phylip_phyml_tree_$name.txt |  awk -F ":" '{print $1}' | awk -F "(" '{print $NF}' > whole-IAPLTR1-$name-phylip_phyml_tree-list.txt 




 
