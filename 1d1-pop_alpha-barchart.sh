cd ~/rds/rds-afs-lab-rds-FxufPjywHiE/genomes/Mouse-strains/hybrids

grep -Fwf windowed_tiplabs.txt LTR1s-1d1-all_subspecies-ordered_matrix.txt |
    awk -v OFS="\t" '{if ($2 == 0) {print $1,"p1-n1d1"} else {print $1,"p1-1d1"}}' > temp1

grep -v -Fwf windowed_tiplabs.txt LTR1s-1d1-all_subspecies-ordered_matrix.txt |
   awk -v OFS="\t" '{if ($2 == 0) {print $1,"np1-n1d1"} else {print $1,"np1-1d1"}}' > temp2

cat temp1 temp2 > in-file.txt
Rscript 1d1-pop_alpha-barchart.R

rm temp1 temp2 in-file.txt
