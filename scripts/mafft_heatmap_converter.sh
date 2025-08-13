#!/bin/bash
cd ~/rds/rds-acf1004-afs-lab-rds/genomes/Mouse-strains

#cycle through strains and run reformatting + NT -> number conversion for heatmap making
while read name
do

cd $name
cp trimal-$name.fa in-file.txt
conda activate -n R Rscript ../scripts/trimal_to_heatmap.R
rm in-file.txt 
cd ../

done < mouse-strains-list.txt
