#Extracts solo IAPLTRs, whole IAPLTR TEs with 1d1 deletion, and whole IAPLTR TEs without 1d1 deletion and puts outs into IAPLTR-counts.txt 
#Example usage: bash ~/rds/rds-acf1004-afs-lab-rds/genomes/Mouse-strains/scripts/better-IAPLTR-1d1-puller.sh 

#Steps:
#1) pull out all IAPLTRs of interest alongisde internal elements from fasta.out
#2) bedtools merge TE fragments into whole TE instances > list of whole and solo LTRs
#3) intersect list of whole and solo LTRs with only internal elements > list of solo LTRs + list of whole IAPLTRs
#4a) pull out all internal elements with proper 1d1 deletion marks (end 1308-1318 [deletion] start 3205-3215)
#4b) bedtools intersect 1d1 internals with list of whole IAPLTRs > 1d1 IAPLTRs + non-1d1 whole IAPLTRs
#5) pull specific IAPLTR types from non-1d1 whole IAPLTRs, 1d1 IAPLTRs, and solo LTRs, and count instances 

module load bedtools
cd ~/rds/rds-acf1004-afs-lab-rds/genomes/Mouse-strains/

rm IAPLTR-counts.txt
echo -e "Strain\tLTR_type\tTE_type\tCount" > IAPLTR-counts.txt #header

#Loop through IAPLTR1's, 1a's, and 2's
echo -e "IAPLTR1_Mm\nIAPLTR1a_Mm\nIAPLTR2_Mm" > LTR_to_pull.txt

while read name; do #loop through mice strains
    echo "Pulling from $name"
    cd $name

    #step 1+2: pull out all IAPLTRs of interest alongisde internal elements from fasta.out + bedtools merge TE fragments into whole TE instances > list of whole and solo LTRs 
    grep -w -F -e IAPEz-int -f ../LTR_to_pull.txt $name\_chromosomes_MT_unplaced.fasta.out > all-IAPLTR+Int-$name.fasta.out #step 1
    awk -v OFS="\t" '{print $5,$6,$7,$10,$10,$9}' all-IAPLTR+Int-$name.fasta.out | #convert to bedfile format + sort for bedtools merge
        awk -v OFS="\t" '{if ($6 == "C") {print $1,$2,$3,$4,$5,"-"} else {print $0}}' > all-IAPLTR+Int-$name.bed 
        sort -k1,1 -k2,2n all-IAPLTR+Int-$name.bed |
        bedtools merge -d 200 -i -  > solo+whole-IAPLTR-$name.bed #step 2, outputs as a bed 3
    
    #step 3 : intersect list of whole and solo LTRs with only internal elements > list of solo LTRs + list of whole IAPLTRs 
    bedtools intersect -wa -wb -a all-IAPLTR+Int-$name.bed -b solo+whole-IAPLTR-$name.bed | #intersects bed6 with bed3 of solo + merged whole LTRs
        awk -v OFS="\t" '!seen[$7,$8,$9]++' | #reformatting back into a bed 6 by parsing out repeat intersects of whole IAPLTR with its sub-components
        grep -v -w IAPEz-int | #grepping out the internal elements with no LTRs
        awk -v OFS="\t" '{print $7,$8,$9,$4,$5,$6}' > temp1
    awk -v OFS="\t" '{if ($3 - $2 <= 500) print $0}' temp1 > solo-IAPLTR-$name.bed
    awk -v OFS="\t" '{if ($3 - $2 > 500) print $0}' temp1 > whole-IAPLTR-$name.bed 
    rm temp1

    #step 4 : pull out all internal elements with proper 1d1 deletion marks + intersect 1d1 internals with list of whole IAPLTRs > 1d1 IAPLTRs + non-1d1 whole IAPLTRs 
    grep -w IAPEz-int all-IAPLTR+Int-$name.fasta.out |   #step 4a
    #awk script checks current line and line before to determine proper start and end sites for 1d1 deletion
        awk -v OFS="\t" 'BEGIN { start=0; startline=0 } {
            if ($9 == "+" && start > 1308 && start < 1318 && $12 > 3205 && $12 < 3215){
                print startline;
                print $0;
            }
            else if ($9 == "+") {
                start=$13;
                startline=$0;
            }
            else if ($9 == "C" && $13 > 1308 && $13 < 1318 && start > 3205 && start < 3215){
                print startline;
                print $0;
            }
            else if ($9 == "C") {
                start=$14; 
                startline=$0;
            }
        }'  | 
        awk -v OFS="\t" '{print $5,$6,$7,$10,$10,$9}' | #convert to bedfile format
        awk -v OFS="\t" '{if ($6 == "C") {print $1,$2,$3,$4,$5,"-"} else {print $0}}'|
        bedtools intersect -c -a whole-IAPLTR-$name.bed -b - > temp2 #step 4b

    awk -v OFS="\t" '{if ($7 == 0) print $1,$2,$3,$4,$5,$6}' temp2 > whole-non1d1-IAPLTR-$name.bed
    awk -v OFS="\t" '{if ($7 >= 1) print $1,$2,$3,$4,$5,$6}' temp2 > whole-1d1-IAPLTR-$name.bed  
    rm temp2

    #step 5 : 
    while read LTR; do  
        echo -e "$name\t$LTR\tfull\t$(grep $LTR whole-non1d1-IAPLTR-$name.bed | wc -l)" >> ../IAPLTR-counts.txt
        echo -e "$name\t$LTR\t1delta1\t$(grep $LTR whole-1d1-IAPLTR-$name.bed | wc -l)" >> ../IAPLTR-counts.txt
        echo -e "$name\t$LTR\tsolo\t$(grep $LTR solo-IAPLTR-$name.bed | wc -l)" >> ../IAPLTR-counts.txt
    done < ../LTR_to_pull.txt

    cd ../

done < mouse-strains-list.txt #restart process for next mouse strain
