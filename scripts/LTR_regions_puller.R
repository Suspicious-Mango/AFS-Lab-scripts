require(tidyverse)
require(seqinr)
require(data.table)

temp = fread("in-file.txt", fill=TRUE) %>% #read in a full-TE file
  slice(rep(1:n(), each = 2)) #doubles each row

for (i in seq(1,nrow(temp),2)){
  temp[i,3] = temp[i,2] - 500
  temp[i,2] = temp[i,2] - 1500
  temp[i,4:5] = paste0("downLTR_", (i+1)/2) #downstream LTR rename
  temp[i+1,2] = temp[i+1,3] + 500
  temp[i+1,3] = temp[i+1,3] + 1500
  temp[i+1,4:5] = paste0("upLTR_", (i+1)/2) #upstream LTR rename
}

write.table(filter(temp, V2 > 0), file="outfile.txt", quote=FALSE, 
            row.names=FALSE, col.names=FALSE, sep="\t")
