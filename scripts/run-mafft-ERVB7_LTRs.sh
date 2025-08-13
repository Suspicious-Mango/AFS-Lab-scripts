#directory set by fasta_to_tree pipeline (output to folder with ERVB7_LTRs-$name.fa)
#!/bin/bash
name=$1

#sequence alignment
#mafft ERVB7_LTRs-$name.fa > mafft-ERVB7_LTRs-$name.fa 

#trimming sequence for phyml
#trimal -in mafft-ERVB7_LTRs-$name.fa -out trimal-ERVB7_LTRs-$name.fa -automated1 
#seqret -sequence trimal-ERVB7_LTRs-$name.fa -outseq ERVB7_LTRs-$name.phylip -osformat phylip

#Clustering
phyml -i ERVB7_LTRs-$name.phylip --run_id $name --quiet --no_memory_check > temp-ERVB7_LTRs-$name.out

#Generating list of element IDs in order of the tree
awk -F "," -v OFS="\n" '{$1 = $1 } {print $0}' ERVB7_LTRs-$name.phylip_phyml_tree_$name.txt |  awk -F ":" '{print $1}' | awk -F "(" '{print $NF}' > ERVB7_LTRs-$name-phylip_phyml_tree-list.txt 




 
