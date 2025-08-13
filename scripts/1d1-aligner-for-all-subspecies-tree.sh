cd ~/rds/rds-acf1004-afs-lab-rds/genomes/Mouse-strains/hybrids

#cats all five files to use for phylogenetic clustering
#cat ../SPRET_EiJ/LTR1s-SPRET_EiJ.bed ../JF1_MsJ/LTR1s-JF1_MsJ.bed ../C57BL_6NJ/LTR1s-C57BL_6NJ.bed ../PWK_PhJ/LTR1s-PWK_PhJ.bed ../CAST_EiJ/LTR1s-CAST_EiJ.bed > LTR1s-all_subspecies.bed

#cat ../SPRET_EiJ/LTR1s-SPRET_EiJ.fa ../JF1_MsJ/LTR1s-JF1_MsJ.fa ../C57BL_6NJ/LTR1s-C57BL_6NJ.fa ../PWK_PhJ/LTR1s-PWK_PhJ.fa ../CAST_EiJ/LTR1s-CAST_EiJ.fa > LTR1s-all_subspecies.fa

#cat ../SPRET_EiJ/whole-1d1-IAPLTR-SPRET_EiJ.bed ../JF1_MsJ/whole-1d1-IAPLTR-JF1_MsJ.bed ../C57BL_6NJ/whole-1d1-IAPLTR-C57BL_6NJ.bed ../PWK_PhJ/whole-1d1-IAPLTR-PWK_PhJ.bed ../CAST_EiJ/whole-1d1-IAPLTR-CAST_EiJ.bed |
#    grep IAPLTR1_Mm > whole-1d1-IAPLTR-all_subspecies.bed

#cat ../SPRET_EiJ/whole-IAPLTR1-SPRET_EiJ.bed ../JF1_MsJ/whole-IAPLTR1-JF1_MsJ.bed ../C57BL_6NJ/whole-IAPLTR1-C57BL_6NJ.bed ../PWK_PhJ/whole-IAPLTR1-PWK_PhJ.bed ../CAST_EiJ/whole-IAPLTR1-CAST_EiJ.bed > whole-IAPLTR1-all_subspecies.bed 

#cat ../SPRET_EiJ/whole-IAPLTR1-SPRET_EiJ.fa ../JF1_MsJ/whole-IAPLTR1-JF1_MsJ.fa ../C57BL_6NJ/whole-IAPLTR1-C57BL_6NJ.fa ../PWK_PhJ/whole-IAPLTR1-PWK_PhJ.fa ../CAST_EiJ/whole-IAPLTR1-CAST_EiJ.fa > whole-IAPLTR1-all_subspecies.fa

#cat ../SPRET_EiJ/ERVB7_LTRs-SPRET_EiJ.bed ../JF1_MsJ/ERVB7_LTRs-JF1_MsJ.bed ../C57BL_6NJ/ERVB7_LTRs-C57BL_6NJ.bed ../PWK_PhJ/ERVB7_LTRs-PWK_PhJ.bed ../CAST_EiJ/ERVB7_LTRs-CAST_EiJ.bed > ERVB7_LTRs-all_subspecies.bed

#cat ../SPRET_EiJ/ERVB7_LTRs-SPRET_EiJ.fa ../JF1_MsJ/ERVB7_LTRs-JF1_MsJ.fa ../C57BL_6NJ/ERVB7_LTRs-C57BL_6NJ.fa ../PWK_PhJ/ERVB7_LTRs-PWK_PhJ.fa ../CAST_EiJ/ERVB7_LTRs-CAST_EiJ.fa > ERVB7_LTRs-all_subspecies.fa

<<processing
echo "processing"
#intersects to extract all LTR1s associated with the 1d1 deletion
bedtools intersect -c -a LTR1s-all_subspecies.bed -b whole-1d1-IAPLTR-all_subspecies.bed > LTR1s-1d1-all_subspecies.bed 

#wiping file beforehand to avoid infinite appending
rm convert-name-all_subspecies.ordered.bed
rm msa-all_subspecies.ordered.txt

while read ID ; #loops through all elements of the phylogeny in order, from top of the tree to the bottom
do
    grep -w $ID LTR1s-1d1-all_subspecies.bed >> convert-name-all_subspecies.ordered.bed #1d1's in order of tree
    grep -w $ID msa-all_substrains.txt >> msa-all_subspecies.ordered.txt #trimal in order of tree
done < all_subspecies-phylip_phyml_tree-list.txt

cut -f4,7 convert-name-all_subspecies.ordered.bed > LTR1s-1d1-all_subspecies-ordered_matrix.txt #extracting just the ID's and whether or not it is associated with a 1d1 (1 for yes, 0 for no)
processing
