#[DEPRECATED]
##Converts a fasta.out into an LTR fasta (made for T2T black6)
##conda activate R, module load bedtools
name=$1

module load bedtools
cd ~/rds/rds-acf1004-afs-lab-rds/genomes/Mouse-strains/$name

#get all full-length IAPLTR1 TEs (int + LTR)
awk -v OFS="\t" '{print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15}' $name\_chromosomes_MT_unplaced.fasta.out > in-file.txt 
Rscript ../scripts/IAPLTR1-puller.R
mv outfile.fulls.txt IAPLTR1-TE-$name.bed
rm in-file.txt

#get all IAPLTRs and internal elements, reformat, then get just IAPLTR1s (LTR only)
grep -e IAPEz-int -e IAPLTR $name\_chromosomes_MT_unplaced.fasta.out |
	awk '{if ($9 == "C") $9 ="-"} {print $5 "\t" $6 "\t" $7 "\t" $10 "\t" $15 "\t" $9}' > all-IAPLTRs-$name.bed
grep IAPLTR1_Mm all-IAPLTRs-$name.bed > temp

#overlap to get IAPLTR1s next to full length elements, reformat, then getfasta for LTRs 
bedtools window -w 150 -u -a temp -b IAPLTR1-TE-$name.bed |
       	awk -v OFS="\t" '{print $1,$2,$3,$4,$5,$6}' > in-file.txt
Rscript ../scripts/name_adder_for_mafft.R $name
cp outfile.txt LTR1s-$name.bed 
bedtools getfasta -name -s -fi $name\_chromosomes_MT_unplaced.fasta -bed LTR1s-$name.bed -fo LTR1s-$name.fa

rm in-file.txt outfile.solos.txt outfile.all.txt temp
