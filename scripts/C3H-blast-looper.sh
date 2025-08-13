#[DEPRECATED]
#BLASTs 1000bp upstream or downstream of IAPLTR1s, depending on if its on the 3' or 5' end of the internal element
#Loops through all strain directories against refname, which is passed in
# ! conda activate blast !

cd ~/rds/rds-acf1004-afs-lab-rds/genomes/Mouse-strains

refname=$1 
while read name
	do if [$name != $refname] #skips refname so it doesn't take a blast of itself
	then
		cd $name #output goes into this directory
		blastn -task blastn -query ../$refname/IAPLTR1-flanks-$refname.fa -db $name\_chromosomes_MT_unplaced.fasta -outfmt 6 > blast-$refname-$name.txt
		cd ../ #back to Mouse-strains
	fi
done < mouse-strains-list.txt


#submit this to server via 'conda run -n blast ~/rds/rds-acf1004-afs-lab-rds/genomes/Mouse-strains/scripts/submit-blast-cclake.sh'
