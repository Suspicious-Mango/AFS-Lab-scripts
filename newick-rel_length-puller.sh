#series of awk's to seperate the tree apart by tip label in first col and the rel lengths in the following cols
awk -F "," -v OFS="\n" '{$1 = $1 } {print $0}' all_subspecies.phylip_phyml_tree_all_subspecies.txt | 
    awk -F ":" -v OFS="\t" '{$1 = $1 } {print $0}' |  
    awk -F "(" '{print $NF}' | 
    awk -F ")" -v OFS="\t" '{$1 = $1 } {print $0}' | 
    awk -F "\t|-1.000000" '{$1 = $1 } {print $0}' > deconstructed.temp

filelength=$(wc -l deconstructed.temp | cut -f1)

cut -d " " -f2- deconstructed.temp |
    awk '{sum+=$1 ; $1=sum ; print}' | cut -d " " -f1 > colsum.temp 

max=$(awk 'END{print $1}' colsum.temp)

cut -d " " -f1 deconstructed.temp >  deconstructed_names.temp 
paste deconstructed_names.temp colsum.temp | 
    awk -F " " -v max=$max -v OFS="\t" '{print $1, $2, $2/max}' > newick_distcounts_normed.txt
rm deconstructed.temp colsum.temp deconstructed_names.temp 