#Runs alignment for two genomes via minimap2 and then syri for VCF files (to later become chain files)
#pass in names of strains to test

#!/bin/bash
cd ~/rds/rds-acf1004-afs-lab-rds/genomes/Mouse-strains/

#setting up variables for reference genome (full fasta)
refgenome=$1
cd $refgenome
ref_in=$refgenome\_chromosomes_MT_unplaced.fasta
cd ../

#setting up variables for query genome (full fasta)
qrygenome=$2
cd $qrygenome
qry_in=$qrygenome\_chromosomes_MT_unplaced.fasta
cd ../

#running doodads
cd liftOver
minimap2 -ax asm5 --eqx $ref_in $qry_in > $refgenome-$qrygenome-out.sam
syri -c $refgenome-$qrygenome-out.sam -r $ref_in -q $qry_in -k -F S
