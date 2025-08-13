suppressMessages(require(dplyr))
suppressMessages(require(data.table))

data = read.table("in-file.txt") #read in a table of chi-squared test statistics
original_test_stat = data[1,] #saving original chi sqr
greater_than_origional = rep(0, ncol(data)) #defining a matrix to save # of control test statistics greater than original

for (i in 1:ncol(data)){ #loop through columns
    for (j in 2:nrow(data)) { #loop through control test statistics 
  	if (data[j,i] > original_test_stat[i]) {
    		greater_than_origional[i] = greater_than_origional[i] + 1 #if that test stat is > original, add to tally in greater_than_origional
  	    }
    }
}

p_val = greater_than_origional / (nrow(data) - 1) #calculate p-value from test statistics
write.table(p_val, file="outfile.txt", quote=FALSE,
            row.names=FALSE, col.names=FALSE, sep="\t") #save
