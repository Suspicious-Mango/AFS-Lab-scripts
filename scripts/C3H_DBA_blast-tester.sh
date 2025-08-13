#[DEPRECATED]
#test script for blastn using C3H and DBA. Didn't work as well as hoped, so we moved to using liftOver
#!/bin/bash

blastn -task blastn -query ~/rds/rds-acf1004-afs-lab-rds/genomes/Mouse-strains/C3H_HeJ/IAPLTR1-flanks-C3H_HeJ.fa -db ~/rds/rds-acf1004-afs-lab-rds/genomes/Mouse-strains/DBA_2J/DBA_2J_chromosomes_MT_unplaced.fasta -outfmt 6 > blast-C3H_HeJ-DBA_2J.txt
