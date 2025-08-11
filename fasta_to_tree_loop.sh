#iterates down mouse-strains-list (which are the directory folders also) and runs fasta_to_tree on each.
#! EDIT FASTA_TO_TREE BEFORE RUNNING LOOP !
#if doing sequence alignment: conda activate mafft_conda
#if doing tree generation: conda activate R
cd ~/rds/rds-acf1004-afs-lab-rds/genomes/Mouse-strains

while read name
	do cd $name
	bash ../scripts/fasta_to_tree.sh $name
	cd ../
	done < mouse-strains-list.txt
