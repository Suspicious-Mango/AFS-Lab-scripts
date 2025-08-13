#!/bin/bash
#Example of how to convert a fasta.out into a bed6
for file in ./*.txt
do  
  name=`basename $file .txt`
  cut -f5,6,7,10,15,9 $file | 
    sed 's/C/-/g' > $name.bed
done
