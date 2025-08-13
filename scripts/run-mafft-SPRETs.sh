#directory set by fasta_to_tree pipeline
#!/bin/bash
name=$1

#sequence alignment
mafft $name.fa > mafft-$name.fa 

#trimming sequences for phyml
trimal -in mafft-$name.fa -out trimal-$name.fa -automated1 
seqret -sequence trimal-$name.fa -outseq $name.phylip -osformat phylip

#Clustering
phyml -i $name.phylip --run_id $name --quiet --no_memory_check > temp-$name.out

#Saving list of IDs in order of tree
awk -F "," -v OFS="\n" '{$1 = $1 } {print $0}' $name.phylip_phyml_tree_$name.txt |  awk -F ":" '{print $1}' | awk -F "(" '{print $NF}' > $name-phylip_phyml_tree-list.txt 




 
