#Step 1) takes gff3 (liftoff output) and converts into a bed 6
#Step 2) adds ase info as a 7th column

#!/bin/bash
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
grep -Fwf ids-in-ase-temp.txt $name.bed | cut -f5 | nl -b a > ids-in-both-files-temp.txt

#for progress bar
max=`wc -l ids-in-both-files-temp.txt | awk '{print $1}'`
X="$(printf "%.0f" $(echo "$max*0.10" | bc -l))"
XX="$(printf "%.0f" $(echo "$max*0.20" | bc -l))"
XXX="$(printf "%.0f" $(echo "$max*0.30" | bc -l))"
XL="$(printf "%.0f" $(echo "$max*0.40" | bc -l))"
L="$(printf "%.0f" $(echo "$max*0.50" | bc -l))"
LX="$(printf "%.0f" $(echo "$max*0.60" | bc -l))"
LXX="$(printf "%.0f" $(echo "$max*0.70" | bc -l))"
XXC="$(printf "%.0f" $(echo "$max*0.80" | bc -l))"
XC="$(printf "%.0f" $(echo "$max*0.90" | bc -l))"

rm $name.ase_bed.txt #safety delete to avoid infinite appending

while read iter id #loops through IDs present in both the bed6 and ase file
do 
#file editing	
        var=`grep $id $name.bed`
        grep $id sorted-ase.txt |
                awk -v var="$var" '{print var "\t" $0 }' >> $name.ase_bed.txt #prints all variants in ase with ID along with bed6 info
#progress bar
	if [iter -eq 1]; then
                echo -ne '[----------] (0%)\r'
        elif [iter -eq $X ];then
                sleep 1
                echo -ne '[#---------] (10%)\r'
        elif [iter -eq $XX ];then
                sleep 1
                echo -ne '[##--------] (20%)\r'
        elif [iter -eq $XX ];then
                sleep 1
                echo -ne '[##--------] (20%)\r'
        elif [iter -eq $XXX ];then
                sleep 1
                echo -ne '[###-------] (30%)\r'
        elif [iter -eq $XL ];then
                sleep 1
                echo -ne '[####------] (40%)\r'
        elif [iter -eq $L ];then
                sleep 1
                echo -ne '[#####-----] (50%)\r'
        elif [iter -eq $LX ];then
                sleep 1
                echo -ne '[######----] (60%)\r'
        elif [iter -eq $LXX ];then
                sleep 1
                echo -ne '[#######---] (70%)\r'
        elif [iter -eq $XXC ];then
                sleep 1
                echo -ne '[########--] (80%)\r'
        elif [iter -eq $XC ];then
                sleep 1
                echo -ne '[#########-] (90%)\r'
        else
                sleep 1
                echo -ne '[##########] (100%)\r'
        fi
done < ids-in-both-files-temp.txt

rm ids-in-both-files-temp.txt sorted-ase.txt ids-in-ase-temp.txt #clean up
