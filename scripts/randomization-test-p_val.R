suppressMessages(require(dplyr))
suppressMessages(require(data.table))

data = read.table("in-file.txt")
original_test_stat = data[1,]
greater_than_origional = rep(0, ncol(data))

for (i in 1:ncol(data)){
    for (j in 2:nrow(data)) {
  	if (data[j,i] > original_test_stat[i]) {
    		greater_than_origional[i] = greater_than_origional[i] + 1
  	}
    }
}

p_val = greater_than_origional / (nrow(data) - 1)
write.table(p_val, file="outfile.txt", quote=FALSE,
            row.names=FALSE, col.names=FALSE, sep="\t")
