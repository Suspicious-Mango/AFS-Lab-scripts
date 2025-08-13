#[DEPRECATED]
##pass in strain name to cluster + turn into a tree. Assumes you are in the file's directory and outputs to that folder
#for full pipline, run bed_to_LTR1_fasta.sh first
#!/bin/bash
name=$1

##run sequence alignment first
## ! conda activate mafft_conda !

#<<cluster
sbatch ~/rds/rds-acf1004-afs-lab-rds/genomes/Mouse-strains/submit-job-cclake.sh $name
#cluster
#runs "bash ./scripts/run-mafft-cluster.sh $1" on server, which runs mafft, trimal, seqret, and phyml to generate the newick file

##run tree maker second
## ! conda activate R !

<<tree
cp $name.phylip_phyml_tree_$name.txt in-tree.txt
cp trimal-$name.fa in-fasta.txt
Rscript ../scripts/tree_grower.R
cp outfile.png LTR1_phylogeny_$name.png
rm in-tree.txt in-fasta.txt outfile.png
tree


