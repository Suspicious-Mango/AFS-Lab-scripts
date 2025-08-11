#directory set by fasta_to_tree pipeline
name=$1


mafft $name.fa > mafft-$name.fa 
trimal -in mafft-$name.fa -out trimal-$name.fa -automated1 
seqret -sequence trimal-$name.fa -outseq $name.phylip -osformat phylip
#seqret -sequence mafft-$name.fa -outseq $name.phylip -osformat phylip
phyml -i $name.phylip --run_id $name --quiet --no_memory_check > temp-$name.out

awk -F "," -v OFS="\n" '{$1 = $1 } {print $0}' $name.phylip_phyml_tree_$name.txt |  awk -F ":" '{print $1}' | awk -F "(" '{print $NF}' > $name-phylip_phyml_tree-list.txt 




 
