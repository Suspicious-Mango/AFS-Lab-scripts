strain1=$1
strain2=$2
path_to_mappings=~/rds/rds-acf1004-afs-lab-rds/genomes/Mouse-strains/liftOver/T2T
path_to_Rscripts=~/rds/rds-acf1004-afs-lab-rds/genomes/Mouse-strains/scripts

cd ~/rds/rds-acf1004-afs-lab-rds/genomes/T2T/chainfiles/mapping-cast-Bl6-transcripts

module load bedtools

<<experimental_data

#Extracting DEGs from ase_bed file and condensing to only the first NT, aka the TSS
grep -w FLAG_significance $strain2.liftoff.ase_bed.txt |
        awk -v OFS="\t" '{print $1,$2,$3,$4,$5,$6}' > $strain2.DEGs.bed #deletes last row for bedtools
awk -v OFS="\t" '{ if($6 == "-") { print $1,$3,$3,$4,$5,$6 } else { print $1,$2,$2,$4,$5,$6 }}' $strain2.DEGs.bed > $strain2.TSS_DEGs.bed


##- strain1 to strain2, shared or conserved LTR1s near DEGs? -##

	#Separating shared vs strain specific LTR1s from liftOver mapping
	awk -v OFS="\t" '{if ($7 == 0) print $1,$2,$3,$4,$5,$6}' $path_to_mappings/LTR1-$strain1-to-$strain2-mapping.bed > ss-LTR1-$strain1-to-$strain2-mapping.bed
	awk -v OFS="\t" '{if ($7 != 0) print $1,$2,$3,$4,$5,$6}' $path_to_mappings/LTR1-$strain1-to-$strain2-mapping.bed > shared-LTR1-$strain1-to-$strain2-mapping.bed

	#Pulling overlap of TSS DEGs with shared and strain specific
	bedtools window -w 1000000 -c -a $strain2.TSS_DEGs.bed -b ss-LTR1-$strain1-to-$strain2-mapping.bed | uniq > ss-TSS_DEG-$strain1-to-$strain2.bed
	bedtools window -w 1000000 -c -a $strain2.TSS_DEGs.bed -b shared-LTR1-$strain1-to-$strain2-mapping.bed | uniq > shared-TSS_DEG-$strain1-to-$strain2.bed


##- strain 2, variably methylated LTR1 or not VM LTR1 near DEGs? -##

	#VM_IAP file has Vm LTRs for LTR1, 1a, 2, 2a, and 4. This pulls for 1 and 1a since 1a's may be misannotated
	grep IAPLTR1 $path_to_mappings/$strain2.chromosomes_unplaced.fasta.out |
       		awk -v OFS="\t" '{if ($9 == "C") $9 ="-"} {print $5,$6,$7,$10,$15,$9}' | 
		bedtools intersect -c -a T2T_C57BL_6J.VM_IAP.bed -b - > $strain2.LTR1-VM-test.bed 

	#If LTRs overlaped with those on VM_IAP list, then VM. if not, non-VM
	awk -v OFS="\t" '{if ($5 != 0) print $1,$2,$3,$4}' $strain2.LTR1-VM-test.bed > $strain2.VM_IAPLTR1s.bed
	awk -v OFS="\t" '{if ($5 == 0) print $1,$2,$3,$4}' $strain2.LTR1-VM-test.bed > $strain2.non-VM_IAPLTR1s.bed

	#Pulling DEGs with variably methylated IAPLTR1s as well as pulling DEGs with non variably methylated LTR1s nearby
	bedtools window -w 1000000 -c -a $strain2.TSS_DEGs.bed -b $strain2.VM_IAPLTR1s.bed | uniq > VM_IAPLTR1s-TSS_DEG-$strain2.bed
	bedtools window -w 1000000 -c -a $strain2.TSS_DEGs.bed -b non-VM_IAPLTR1s-$strain2.bed | uniq > non-VM_IAPLTR1s-TSS_DEG-$strain2.bed
experimental_data

##- Quantifying absence and presence -##

	cut -f7 ss-TSS_DEG-$strain1-to-$strain2.bed | sort | uniq -c | awk 'BEGIN { c=0 } {if ($2 >= 1) {c += $1}} END {print c} {if ($2 == 0) {print $1 }}' > ss-counts.txt
	cut -f7 shared-TSS_DEG-$strain1-to-$strain2.bed | sort | uniq -c | awk 'BEGIN { c=0 } {if ($2 >= 1) {c += $1}} END {print c} {if ($2 == 0) {print $1 }}' > shared-counts.txt
	cut -f7 VM_IAPLTR1s-TSS_DEG-$strain2.bed | sort | uniq -c | awk 'BEGIN { c=0 } {if ($2 >= 1) {c += $1}} END {print c} {if ($2 == 0) {print $1 }}' > VM-counts.txt
	cut -f7 non-VM_IAPLTR1s-TSS_DEG-$strain2.bed | sort | uniq -c | awk 'BEGIN { c=0 } {if ($2 >= 1) {c += $1}} END {print c} {if ($2 == 0) {print $1 }}' > non-VM-counts.txt

#experimental_data

#<<significance_testing

rm p_val-matrix.txt
echo -e 'SS\t  Shared\t VM\t non-VM' > p_val-matrix.txt

for i in {1..100}
do
	rm in-matrix.txt
	echo -e 'SS\t SS-control\t Shared\t Shared-control\t VM\t VM-control\t non-VM\t non-VM-control' > in-matrix.txt

	#Scrambling and remapping for background control
	bedtools shuffle -g ../../Bl6/T2T_C57BL_6J.chrom.sizes -i ss-LTR1-$strain1-to-$strain2-mapping.bed | 
		bedtools window -w 1000000 -c -a $strain2.TSS_DEGs.bed -b - | uniq |
		cut -f7 | sort | uniq -c | awk 'BEGIN { c=0 } {if ($2 >= 1) {c += $1}} END {print c} {if ($2 == 0) {print $1 }}' > ss-control-counts.txt

	bedtools shuffle -g ../../Bl6/T2T_C57BL_6J.chrom.sizes -i shared-LTR1-$strain1-to-$strain2-mapping.bed | 
		bedtools window -w 1000000 -c -a $strain2.TSS_DEGs.bed -b - | uniq |
        	cut -f7 | sort | uniq -c | awk 'BEGIN { c=0 } {if ($2 >= 1) {c += $1}} END {print c} {if ($2 == 0) {print $1 }}' > shared-control-counts.txt

	bedtools shuffle -g ../../Bl6/T2T_C57BL_6J.chrom.sizes -i $strain2.VM_IAPLTR1s.bed | 
		bedtools window -w 1000000 -c -a $strain2.TSS_DEGs.bed -b - | uniq |
        	cut -f7 | sort | uniq -c | awk 'BEGIN { c=0 } {if ($2 >= 1) {c += $1}} END {print c} {if ($2 == 0) {print $1 }}' > VM-control-counts.txt

	bedtools shuffle -g ../../Bl6/T2T_C57BL_6J.chrom.sizes -i non-VM_IAPLTR1s-$strain2.bed |
       		bedtools window -w 1000000 -c -a $strain2.TSS_DEGs.bed -b - | uniq |
        	cut -f7 | sort | uniq -c | awk 'BEGIN { c=0 } {if ($2 >= 1) {c += $1}} END {print c} {if ($2 == 0) {print $1 }}' > non-VM-control-counts.txt

	paste ss-counts.txt ss-control-counts.txt shared-counts.txt shared-control-counts.txt VM-counts.txt VM-control-counts.txt non-VM-counts.txt non-VM-control-counts.txt >> in-matrix.txt

	conda run -n R Rscript $path_to_Rscripts/Chi-squared.R
	cat outfile.txt >> p_val-matrix.txt
done

conda run -n R Rscript $path_to_Rscripts/p_val-averager.R
cp outfile.txt avg-p_vals.txt
#significance_testing



