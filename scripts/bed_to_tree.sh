#combination of bed_to_LTR1_fasta.sh and fasta_to_tree.sh
module load bedtools

while read name
do 
cd ~/rds/rds-acf1004-afs-lab-rds/genomes/Mouse-strains/$name

#(bed_to_LTR1_fasta.sh) get all full-length IAPLTR1 TEs, then get all IAPLTRs next to internal elements, reformat, then getfasta IAPLTR1s

#get all full-length IAPLTR1 TEs (int + LTR)
awk -v OFS="\t" '{print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15}' $name\_chromosomes_MT_unplaced.fasta.out > in-file.txt 
conda run -n R Rscript ../scripts/IAPLTR1-puller.R
mv outfile.fulls.txt IAPLTR1-TE-$name.bed
rm in-file.txt

#get all IAPLTRs and internal elements, reformat, then get just IAPLTR1s (LTR only)
grep -e IAPEz-int -e IAPLTR $name\_chromosomes_MT_unplaced.fasta.out |
        awk '{if ($9 == "C") $9 ="-"} {print $5 "\t" $6 "\t" $7 "\t" $10 "\t" $15 "\t" $9}' > all-IAPLTRs-$name.bed
grep IAPLTR1_Mm all-IAPLTRs-$name.bed > temp

#overlap to get IAPLTR1s next to full length elements, reformat, then getfasta for LTRs 
bedtools window -w 150 -u -a temp -b IAPLTR1-TE-$name.bed |
        awk -v OFS="\t" '{print $1,$2,$3,$4,$5,$6}' > in-file.txt
conda run -n R Rscript ../scripts/name_adder_for_mafft.R $name
bedtools getfasta -name -s -fi $name\_chromosomes_MT_unplaced.fasta -bed outfile.txt -fo LTR1s-$name.fa

rm in-file.txt outfile.solos.txt outfile.all.txt temp outfile.txt

#(fasta_to_tree.sh) run mafft on the LTRs

#sbatch ~/rds/rds-acf1004-afs-lab-rds/genomes/Mouse-strains/submit-job-cclake.sh $name #activates mafft_conda also

#runs "bash ./scripts/run-mafft-cluster.sh $1" on server

#run-mafft-cluster:
    # mafft LTR1s-$name.fa > mafft-$name.fa 
    # trimal -in mafft-$name.fa -out trimal-$name.fa -automated1 
    # seqret -sequence trimal-$name.fa -outseq $name.phylip -osformat phylip
    # phyml -i $name.phylip --run_id $name --quiet --no_memory_check > temp-$name.out
    # awk -F "," -v OFS="\n" '{$1 = $1 } {print $0}' $name.phylip_phyml_tree_$name.txt |  awk -F ":" '{print $1}' | awk -F "(" '{print $NF}' > $name-phylip_phyml_tree-list.txt
#end of script

done < ~/rds/rds-acf1004-afs-lab-rds/genomes/Mouse-strains/mouse-strains+hybrids-list.txt
