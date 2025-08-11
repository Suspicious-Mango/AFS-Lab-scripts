suppressMessages(require(dplyr))
suppressMessages(require(data.table))

#ss-counts.txt ss-control-counts.txt shared-counts.txt shared-control-counts.txt VM-counts.txt VM-control-counts.txt non-VM-counts.txt non-VM-control-counts.txt

#in-matrix.txt example
#SS SS-control Shared Shared-control VM VM-control non-VM non-VM-control
#9371	1389	14451	14451	13694	13888	5232	9219
#4252	10045	0	0	13	0	1272	13179

data = read.table("in-matrix.txt", header = TRUE)

chi_sqr_ss = chisq.test(data[,1:2])
chi_sqr_shared = chisq.test(data[,3:4])
chi_sqr_VM = chisq.test(data[,5:6])
chi_sqr_nonVM = chisq.test(data[,7:8])


chi_sqr_table = as.table(matrix(c(chi_sqr_ss$p.value, chi_sqr_shared$p.value, chi_sqr_VM$p.value, chi_sqr_nonVM$p.value),
			       	nrow = 1, ncol = 4))


write.table(chi_sqr_table, file="outfile.txt", quote=FALSE, 
            row.names=FALSE, col.names=FALSE, sep="\t")
