suppressMessages(require(dplyr))
suppressMessages(require(data.table))

data = read.table("p_val-matrix.txt", header = TRUE) #read in p-values from DEG-enrichment.sh

data2 = data.frame("SS_avg" = mean(data$SS, na.rm = TRUE), 
                   "Shared_avg" = mean(data$shared, na.rm = TRUE), 
                   "VM_avg" = mean(data$VM, na.rm = TRUE), 
                   "non-VM_avg" = mean(data$non_VM, na.rm = TRUE)) #take averages of each column and save as a data frame

write.table(data2, file="p_val-averages.txt", quote=FALSE, 
            row.names=FALSE, col.names=TRUE, sep="\t") #saving
