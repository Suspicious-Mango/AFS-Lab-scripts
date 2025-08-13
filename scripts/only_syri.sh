#Runs alignment for two genomes via minimap2 and then syri for VCF files (to later become chain files)
#pass in names of strains to test
# ! conda activate liftOver !
#!/bin/bash
cd ~/rds/rds-acf1004-afs-lab-rds/genomes/Mouse-strains/liftOver

#setting up variables for reference genome (full fasta)
refgenome=$1
ref_in=../$refgenome/$refgenome\_chromosomes_MT_unplaced.fasta

#setting up variables for query genome (full fasta)
qrygenome=$2
qry_in=../$qrygenome/$qrygenome\_chromosomes_MT_unplaced.fasta

#running doodads
#minimap2 -ax asm5 -t 10 --eqx $ref_in $qry_in > $refgenome-$qrygenome-out.sam
syri -c $refgenome-$qrygenome-out.sam -r $ref_in -q $qry_in -k -F S
