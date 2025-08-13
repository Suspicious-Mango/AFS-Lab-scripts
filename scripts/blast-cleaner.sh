#[DEPRECATED]
#takes blast output file and reformats, checks for nearby LTR1s and returns a 1 if yes, 0 if no
#passes in strain name and cleans for every reference genome
cd ~/rds/rds-acf1004-afs-lab-rds/genomes/Mouse-strains
module load bedtools

name=$1

cd $name
for file in *-$name-blast.txt
	do ref_name=`basename $file -$name-blast.txt`
	awk '!seen[$1]++' $file | #prints first instance of every hit (best quality)
		#reformat into chr of LTRs, start pos, end pos, pos in reference, and quality score
		awk '{ if ($9 > $10) {print $2 "\t" $10 "\t" $9 "\t" $1 "\t" $12} else {print $2 "\t" $9 "\t" $10 "\t" $1 "\t" $12} }' > blast_temp
	grep IAPLTR1 all-IAP-$name.bed > IAP_temp

	bedtools window -w 500 -c -a blast_temp -b IAP_temp | #counts hits of overlaps
		sed 's/\<[2-9]\>/1/g' > $ref_name-$name-blastcount.txt #replaces every number greater than one (to one decimal place) to 1 + saves
done
