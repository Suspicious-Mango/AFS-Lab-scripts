#[DEPRECATED]
#change submit job input to "run-mafft-cluster.sh all-IAP-$1.fa"

module load bedtools

while read name 
do 

## Run this section first with the R conda enviroment 
## conda activate R

#grep IAPLTR1_Mm $name/all-IAP-$name.bed > in-file.txt

#Rscript scripts/name_adder_for_mafft.R
#bedtools getfasta -fi $name/$name\_chromosomes_MT_unplaced.fasta -bed outfile.txt -s -name -fo $name/all-IAP-$name.fa
#rm in-file.txt outfile.txt


#run this second withthe mafft_conda conda env 
# conda active mafft_conda
 sbatch submit-job-cclake.sh $name

done < mouse-strains-list.txt




