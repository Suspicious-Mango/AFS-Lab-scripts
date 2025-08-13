#series of awk's to seperate the tree apart by tip label in first col and the rel lengths in the following cols
#!/bin/bash

awk -F "," -v OFS="\n" '{$1 = $1 } {print $0}' all_subspecies.phylip_phyml_tree_all_subspecies.txt | 
    awk -F ":" -v OFS="\t" '{$1 = $1 } {print $0}' |  
    awk -F "(" '{print $NF}' | 
    awk -F ")" -v OFS="\t" '{$1 = $1 } {print $0}' | 
    awk -F "\t|-1.000000" '{$1 = $1 } {print $0}' > deconstructed.temp

#save the length of the file as an integer
filelength=$(wc -l deconstructed.temp | cut -f1)

#add each prior element of the rel lengths to the next element
cut -d " " -f2- deconstructed.temp |
    awk '{sum+=$1 ; $1=sum ; print}' | cut -d " " -f1 > colsum.temp 

#save maximum length
max=$(awk 'END{print $1}' colsum.temp)

cut -d " " -f1 deconstructed.temp >  deconstructed_names.temp #take only the names
paste deconstructed_names.temp colsum.temp | #put the names back with the summed column values
    awk -F " " -v max=$max -v OFS="\t" '{print $1, $2, $2/max}' > newick_distcounts_normed.txt #generate a third column with normalized lengths from 0 to 1
rm deconstructed.temp colsum.temp deconstructed_names.temp #cleanup
