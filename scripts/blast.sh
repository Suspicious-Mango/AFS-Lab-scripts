#!/bin/bash
#[DEPRECATED]
  
module load blast
cd peaks
#blastn -task blastn -query top25_intersect_expand.fa -db ~/rds/rds-acf1004-afs-lab-rds/genomes/mm39/mm39.fa -outfmt 6 > mm39-blasted-loci.txt
#awk '!seen[$1]++' mm39-blasted-loci.txt > top-mm39-loci.txt
#awk '{if ($9 >= $10) {tmp = $9; $9 = $10; $10 = tmp} sub(/^chr/, "", $2); print $2 "\t" $9 "\t" $10 "\t" $1 }' top-mm39-loci.txt > top-mm39-loci.bed


#blastn -task blastn -query top25_union_expand.fa -db ~/rds/rds-acf1004-afs-lab-rds/genomes/mm39/mm39.fa -outfmt 6 > mm39-blasted-union-loci.txt
#awk '!seen[$1]++' mm39-blasted-union-loci.txt > top-mm39-union-loci.txt
#awk '{if ($9 >= $10) {tmp = $9; $9 = $10; $10 = tmp} sub(/^chr/, "", $2); print $2 "\t" $9 "\t" $10 "\t" $1 }' top-mm39-union-loci.txt > top-mm39-union-loci.bed

blastn -task blastn -query filtered_Cast_specific_peaks_expand.fa -db ~/rds/rds-acf1004-afs-lab-rds/genomes/mm39/mm39.fa -outfmt 6 > mm39-blasted-Cast-specific-peaks.txt


