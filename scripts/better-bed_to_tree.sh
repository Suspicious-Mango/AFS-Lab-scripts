#combination of bed_to_LTR1_fasta.sh and fasta_to_tree.sh
module load bedtools
cd  ~/rds/rds-acf1004-afs-lab-rds/genomes/Mouse-strains

#bash scripts/better-IAPLTR-1d1-puller.sh

while read name
do 
cd $name

#grep ERVB7_1-LTR_MM all-ERVB7+Int-$name.bed > in-file.txt
#conda run -n R Rscript ../scripts/name_adder_for_mafft.R $name
#cp outfile.txt ERVB7_LTRs-$name.bed 

grep IAPLTR1_Mm whole-IAPLTR-$name.bed > in-file.txt
conda run -n R Rscript ../scripts/name_adder_for_mafft.R $name
cp outfile.txt whole-IAPLTR1-$name.bed 

echo "Running $name FASTA"
#bedtools getfasta -name -s -fi $name\_chromosomes_MT_unplaced.fasta -bed ERVB7_LTRs-$name.bed  -fo ERVB7_LTRs-$name.fa
bedtools getfasta -name -s -fi $name\_chromosomes_MT_unplaced.fasta -bed whole-IAPLTR1-$name.bed -fo  whole-IAPLTR1-$name.fa

rm in-file.txt outfile.txt

cd ../
#(fasta_to_tree.sh) run mafft on the LTRs

#runs "bash ./scripts/run-mafft-cluster.sh $1" on server. activates mafft_conda internally
#sbatch ~/rds/rds-acf1004-afs-lab-rds/genomes/Mouse-strains/submit-job-cclake.sh $name 

#run-mafft-cluster:
    # mafft LTR1s-$name.fa > mafft-$name.fa 
    # trimal -in mafft-$name.fa -out trimal-$name.fa -automated1 
    # seqret -sequence trimal-$name.fa -outseq $name.phylip -osformat phylip
    # phyml -i $name.phylip --run_id $name --quiet --no_memory_check > temp-$name.out
    # awk -F "," -v OFS="\n" '{$1 = $1 } {print $0}' $name.phylip_phyml_tree_$name.txt |  awk -F ":" '{print $1}' | awk -F "(" '{print $NF}' > $name-phylip_phyml_tree-list.txt
#end of script

done < ~/rds/rds-acf1004-afs-lab-rds/genomes/Mouse-strains/mouse-strains-list.txt
