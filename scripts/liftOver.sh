#steps:
#No longer used: 
#1) Take fasta.out and pull all full length TEs next to IAPLTR1s with IAPLTR1-puller.R into a .bed file, both strains
#2) bedtools window output with fasta.out to pull out the positions IAPLTR1s, both strains

#Still in use
#3) get 1kb regions adjacent to IAPLTR1s using LTR_regions_puller.R, strain 1
#4) make chain file
#5) liftOver LTR-flanks-strain1.bed strain1_to_strain2.chain outfile.bed unmapped_output (may need to adjust minMatch, look at output)
#6) bedtools window -w 1000 -a output.bed -b LTR1s-strain2.bed > non_strain_specific_LTR1s.bed

#Below script is test run with CAST and Bl6
#! input format: bash liftOver.sh strain1 strain2 !
module load bedtools
module load bcftools

#!/bin/bash
cd ~/rds/rds-acf1004-afs-lab-rds/genomes/Mouse-strains/liftOver/T2T

strain1=$1
strain2=$2

<<deprecated
#step 1
awk -v OFS="\t" '{print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15}' $strain1.chromosomes_unplaced.fasta.out > in-file.txt
Rscript ../../scripts/IAPLTR1-puller.R
mv outfile.fulls.txt IAPLTR1-TE-$strain1.bed

rm in-file.txt

awk -v OFS="\t" '{print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15}' $strain2.chromosomes_unplaced.fasta.out > in-file.txt
Rscript ../../scripts/IAPLTR1-puller.R
mv outfile.solos.txt IAPLTR1-TE-$strain2.bed

rm in-file.txt outfile.fulls.txt outfile.all.txt

#step 2
awk -v OFS="\t" '{if ($9 == "C") $9 ="-"} {print $5,$6,$7,$10,$9,$15}' $strain1.chromosomes_unplaced.fasta.out |
	grep IAPLTR1_Mm | 
	bedtools window -w 100 -u -a - -b IAPLTR1-TE-$strain1.bed > LTR1s-$strain1.bed
awk -v OFS="\t" '{if ($9 == "C") $9 ="-"} {print $5,$6,$7,$10,$9,$15}' $strain2.chromosomes_unplaced.fasta.out |
    grep IAPLTR1_Mm | 
	bedtools window -w 100 -u -a - -b IAPLTR1-TE-$strain2.bed > LTR1s-$strain2.bed 

rm temp1 temp2

#step 3
cp IAPLTR1-TE-$strain1.bed in-file.txt
Rscript ../../scripts/LTR_regions_puller.R
mv outfile.txt LTR1-flanks-$strain1.bed

rm in-file.txt
deprecated

#step 3
if ! test -f LTR1-flanks-$strain1.bed; then
	cp ../../$strain1/whole-IAPLTR-$strain1.bed in-file.txt
	conda run -n R Rscript ../../scripts/LTR_regions_puller.R
	mv outfile.txt LTR1-flanks-$strain1.bed
fi

if ! test -f LTR1-flanks-$strain2.bed; then
	cp ../../$strain2/whole-IAPLTR-$strain2.bed in-file.txt
	conda run -n R Rscript ../../scripts/LTR_regions_puller.R
	mv outfile.txt LTR1-flanks-$strain2.bed
fi


#step 4
bcftools consensus -c $strain1-to-$strain2.chain -f ../../$refgenome/$refgenome\_chromosomes_MT_unplaced.fasta vcffile > consensus.fa
conda run -n liftOver chainSwap $strain1-to-$strain2.chain $strain2-to-$strain1.chain 

#step 5 (runs liftOver, the executable, in liftOver, the conda enviornment)
conda run -n liftOver liftOver -minMatch=0.50 -multiple LTR1-flanks-$strain1.bed $strain1-to-$strain2.chain liftOver-LTR1-$strain1-to-$strain2.bed LTR1-$strain1-to-$strain2-unmapped_output
conda run -n liftOver liftOver -minMatch=0.50 -multiple LTR1-flanks-$strain1.bed $strain2-to-$strain1.chain liftOver-LTR1-$strain2-to-$strain1.bed LTR1-$strain2-to-$strain1-unmapped_output

#step 6
bedtools window -w 1000 -c -a liftOver-LTR1-$strain1-to-$strain2.bed -b LTR1s-$strain2.bed > LTR1-$strain1-to-$strain2-mapping.bed
bedtools window -w 1000 -c -a liftOver-LTR1-$strain2-to-$strain1.bed -b LTR1s-$strain1.bed > LTR1-$strain2-to-$strain1-mapping.bed

