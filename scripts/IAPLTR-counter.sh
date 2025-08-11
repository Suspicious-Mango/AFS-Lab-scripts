#Script parses fasta.out files of mice strains in Mouse-strains directory and returns a .txt file
#containing all combinations of LTR and strain of interest along with the relative solo, full, and 1d1 IAPLTR count

#example usage: bash ~/rds/rds-acf1004-afs-lab-rds/genomes/Mouse-strains/scripts/IAPLTR-counter.sh 
#edit LTR_to_pull to extract different LTRs
cd ~/rds/rds-acf1004-afs-lab-rds/genomes/Mouse-strains

rm IAPLTR-counts.txt
#Header
echo -e "Strain\tLTR_type\tTE_type\tCount" > IAPLTR-counts.txt
#Loop through IAPLTR1's, 1a's, and 2's
echo -e "IAPLTR1_Mm\nIAPLTR1a_Mm\nIAPLTR2_Mm" > LTR_to_pull.txt
while read name; do
    echo "Pulling from $name"
    cd $name

    cp $name\_chromosomes_MT_unplaced.fasta.out in-file.txt
    #input is fasta.out file of strain
    conda run -n R Rscript ../scripts/IAPLTR-1d1-puller.R
    #output is four files containing all solo IAPLTRs, full length IAPLTR TEs, all full TEs with 1d1 deletions and it's compliment 
 
    #Adding count info to IAPLTR-counts in a format easily read by ggplot2 
    while read LTR; do  
        echo -e "$name\t$LTR\tfull\t$(grep $LTR outfile.non1d1.txt | wc -l)" >> ../IAPLTR-counts.txt
        echo -e "$name\t$LTR\t1delta1\t$(grep $LTR outfile.1d1.txt | wc -l)" >> ../IAPLTR-counts.txt
        echo -e "$name\t$LTR\tsolo\t$(grep $LTR outfile.solos.txt | wc -l)" >> ../IAPLTR-counts.txt
    done < ../LTR_to_pull.txt

#    rm outfile.*.txt #cleanup
    cd ../
done < mouse-strains-list.txt #all mice strains of interest

rm LTR_to_pull.txt
