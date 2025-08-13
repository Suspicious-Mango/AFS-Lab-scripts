suppressMessages(require(dplyr))
suppressMessages(require(data.table))

#in-matrix.txt example
#			SS		SS-control Shared 	Shared-control   VM 	VM-control non-VM non-VM-control
#not found	9371	1400		14451	14451			14154	14363		5232	1400
#    found	5080	13051		0		0				297		88			9219	13051

data = read.table("in-matrix.txt", header = TRUE) #generated from DEG-enrichment.sh

#run chi squared significance tests for each category vs it's control
chi_sqr_ss = chisq.test(data[,1:2]) #SS vs SS-control
chi_sqr_shared = chisq.test(data[,3:4]) #shared vs shared control
chi_sqr_VM = chisq.test(data[,5:6]) #VM vs VM-control
chi_sqr_nonVM = chisq.test(data[,7:8]) #non-VM vs non-VM control

#save pvalues in a 1 X 4 matrix
chi_sqr_table = as.table(matrix(c(chi_sqr_ss$p.value, chi_sqr_shared$p.value, chi_sqr_VM$p.value, chi_sqr_nonVM$p.value),
			       	nrow = 1, ncol = 4))

write.table(chi_sqr_table, file="outfile.txt", quote=FALSE, 
            row.names=FALSE, col.names=FALSE, sep="\t") #save
