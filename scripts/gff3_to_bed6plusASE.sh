#Step 1) takes gff3 (liftoff output) and converts into a bed 6
#Step 2) adds ase info as a 7th column

cd ~/rds/rds-acf1004-afs-lab-rds/genomes/T2T/chainfiles/mapping-cast-Bl6-transcripts
gff3file=$1
asefile=$2
name=`basename $gff3file .gff3`

#1)
#Pulls all genes and regoranizes into bed6 format
grep 'ID=gene' $gff3file | 
       awk -F "\t|;|=|:" -v OFS="\t" '{print $1, $4, $5, $13, $11, $7}' > $name.bed

#2)
#Sorts pulls and sorts IDs in both files for merging
sort -t ',' -k1,1n $asefile > sorted-ase.txt
awk -F ',' '{print $1 }' sorted-ase.txt | uniq > ids-in-ase-temp.txt
grep -Fwf ids-in-ase-temp.txt $name.bed | cut -f5 > ids-in-both-files-temp.txt

rm $name.ase_bed.txt #safety delete to avoid infinite appending

while read id #loops through IDs present in both the bed6 and ase file
do 
	var=`grep $id $name.bed`
	grep $id sorted-ase.txt |
	       	awk -v var="$var" '{print var "\t" $0 }' >> $name.ase_bed.txt #prints all variants in ase with ID along with bed6 info
done < ids-in-both-files-temp.txt

rm ids-in-both-files-temp.txt sorted-ase.txt ids-in-ase-temp.txt #clean up
