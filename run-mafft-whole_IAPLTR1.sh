#directory set by fasta_to_tree pipeline (output to folder with LTR1s-$name.fa)
name=$1

#mafft whole-IAPLTR1-$name.fa > mafft-whole-IAPLTR1-$name.fa 
#trimal -in mafft-whole-IAPLTR1-$name.fa -out trimal-whole-IAPLTR1-$name.fa -automated1 
#seqret -sequence trimal-whole-IAPLTR1-$name.fa -outseq whole-IAPLTR1-$name.phylip -osformat phylip
#seqret -sequence mafft-$name.fa -outseq $name.phylip -osformat phylip
phyml -i whole-IAPLTR1-$name.phylip --run_id $name --quiet --no_memory_check > temp-whole-IAPLTR1-$name.out

awk -F "," -v OFS="\n" '{$1 = $1 } {print $0}' whole-IAPLTR1-$name.phylip_phyml_tree_$name.txt |  awk -F ":" '{print $1}' | awk -F "(" '{print $NF}' > whole-IAPLTR1-$name-phylip_phyml_tree-list.txt 




 
