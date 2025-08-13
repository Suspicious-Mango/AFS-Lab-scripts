#[DEPRECATED]

#!/bin/bash

for file in ./*.out #loops through fasta.out files
do 

  name=`basename $file _chromosomes_MT_unplaced.out` #saves strain name
  cp $file temp.txt 
  conda activate -n R Rscript 1delta1_reader.R 
  mv out.txt $name.txt 

done


