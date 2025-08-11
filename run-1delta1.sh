## conda activate R before running


<<example
129S1_SvImJ_chromosomes_MT_unplaced.fasta.out  C3H_HeJ_chromosomes_MT_unplaced.fasta.out    JF1_MsJ_chromosomes_MT_unplaced.fasta.out     WSB_EiJ_chromosomes_MT_unplaced.fasta.out
129S1_SvImJ_chromosomes_MT_unplaced.fasta.txt  C57BL_6NJ_chromosomes_MT_unplaced.fasta.out  LP_J_chromosomes_MT_unplaced.fasta.out        run-1delta1.sh
1delta1_reader.R                               CAST_EiJ_chromosomes_MT_unplaced.fasta.out   NOD_ShiLtJ_chromosomes_MT_unplaced.fasta.out  temp.txt
AKR_J_chromosomes_MT_unplaced.fasta.out        CBA_J_chromosomes_MT_unplaced.fasta.out      NZO_HlLtJ_chromosomes_MT_unplaced.fasta.out
A_J_chromosomes_MT_unplaced.fasta.out          DBA_2J_chromosomes_MT_unplaced.fasta.out     PWK_PhJ_chromosomes_MT_unplaced.fasta.out
BALB_cJ_chromosomes_MT_unplaced.fasta.out      FVB_NJ_chromosomes_MT_unplaced.fasta.out     SPRET_EiJ_chromosomes_MT_unplaced.fasta.out
example

for file in ./*.out 
do 

  name=`basename $file _chromosomes_MT_unplaced.out` 
  cp $file temp.txt 
  Rscript 1delta1_reader.R 
  mv out.txt $name.txt 

done


