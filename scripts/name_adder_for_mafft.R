suppressMessages(require(tidyverse))
suppressMessages(require(data.table))
suppressMessages(require(stringr))

#pass in name (not actually used for anything anymore, but scripts that call the script all have it this way. It's kept for convenience)
name = commandArgs(trailingOnly=TRUE) 
if (length(name)==0 | length(name)>1) {
  stop("One argument must be supplied (input file).n", call.=FALSE)
}
#name = paste0(substr(, 1, 3), "_") # Prefix for strain names

temp = fread("in-file.txt", fill=TRUE)
name = str_sub(temp$V4, 4, -3) # Prefix for LTR names

temp = temp %>% mutate(name = paste0(name,row_number())) %>% #add row number to name so each has a unique ID
  mutate(name2 = name) %>% #duplicate name for bedtools getfasta
  filter(as.numeric(V3) - as.numeric(V2) > 200) #filter out any LTRs less than 200bp (are likely fragments and not of interest)

write.table(temp[,c(1,2,3,7,8,6)], file="outfile.txt", quote=FALSE, 
            row.names=FALSE, col.names=FALSE, sep="\t") #saving with the new names
