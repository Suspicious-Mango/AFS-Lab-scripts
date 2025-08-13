#[DEPRECATED]
#conda activate R
module load bedtools 

#loops through all the mouse strains
## need to redo CBA 
while read name 
do 

cd ~/rds/rds-acf1004-afs-lab-rds/genomes/Mouse-strains/$name 

#merges the full and delta1 elements together and looks for neighboring IAPLTR1_Mm
  cat merged-1delta1-$name.bed full_TE_$name.bed > all-EzInt-$name.bed 
  grep IAPLTR1_Mm all-IAP-$name.bed > temp 
  bedtools window -w 150 -u -a temp -b all-EzInt-$name.bed > temp2
  awk '{print $1,$2,$3,$4,$5}' temp2 > in.file 


#gets the unique sequence next to the LTRs and makes them into a fasta
  Rscript ../scripts/LTR_regions_puller.R 
  awk '{print $1 "\t" $2 "\t" $3 "\t" $1":"$2"-"$3":" $4  "\t" $1":"$2"-"$3":" $5 "\t+"  }' outfile.txt > IAPLTR1-flanks-$name.bed 
  bedtools getfasta -fi $name\_chromosomes_MT_unplaced.fasta -bed IAPLTR1-flanks-$name.bed -fo IAPLTR1-flanks-$name.fa -name 
  rm in.file outfile.txt temp temp2 


cd ~/rds/rds-acf1004-afs-lab-rds/genomes/Mouse-strains/

done < mouse-strains-list.txt

