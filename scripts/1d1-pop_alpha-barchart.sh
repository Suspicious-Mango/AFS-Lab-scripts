cd ~/rds/rds-afs-lab-rds-FxufPjywHiE/genomes/Mouse-strains/hybrids

#windowed_tiplabs contains the tip labels of the phylogeny and what population it pertains to (in this case, only alpha)
#pulls associated IDs from 1d1 ordered matrix and assigns pop1 and either 1d1 or not 1d1
grep -Fwf windowed_tiplabs.txt LTR1s-1d1-all_subspecies-ordered_matrix.txt |
    awk -v OFS="\t" '{if ($2 == 0) {print $1,"p1-n1d1"} else {print $1,"p1-1d1"}}' > temp1

#pulls complement of IDs from before and assigns not pop1 and either 1d1 or not 1d1
grep -v -Fwf windowed_tiplabs.txt LTR1s-1d1-all_subspecies-ordered_matrix.txt |
   awk -v OFS="\t" '{if ($2 == 0) {print $1,"np1-n1d1"} else {print $1,"np1-1d1"}}' > temp2

cat temp1 temp2 > in-file.txt #stacks files on top of on another
Rscript 1d1-pop_alpha-barchart.R #outputs pop_alpha-Id1-barchart.png (see pop_alpha-Id1-barchart.R)

rm temp1 temp2 in-file.txt #cleanup
