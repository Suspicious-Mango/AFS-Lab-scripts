#conda activate R prior

cd ~/rds/rds-acf1004-afs-lab-rds/genomes/Mouse-strains

while read name
do
#run tree_grower.R for all strains
cd $name
echo -e "\nProcessing $name\n"
cp $name.phylip_phyml_tree_$name.txt in-tree.txt
#cp trimal-$name.fa in-fasta.txt
conda activate -R Rscript ../scripts/tree_grower.R $name
cp outfile.png LTR_phylogeny_$name.png
rm in-tree.txt outfile.png #in-fasta.txt
cd ../

done < mouse-strains+hybrids-list.txt
