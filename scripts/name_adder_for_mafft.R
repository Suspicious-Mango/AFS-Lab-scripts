suppressMessages(require(tidyverse))
suppressMessages(require(data.table))
suppressMessages(require(stringr))

name = commandArgs(trailingOnly=TRUE)
if (length(name)==0 | length(name)>1) {
  stop("One argument must be supplied (input file).n", call.=FALSE)
}
#name = paste0(substr(, 1, 3), "_") # Prefix for strain names

temp = fread("in-file.txt", fill=TRUE)
name = str_sub(temp$V4, 4, -3) # Prefix for LTR names

temp = temp %>% mutate(name = paste0(name,row_number())) %>% 
  mutate(name2 = name) %>%
  filter(as.numeric(V3) - as.numeric(V2) > 200)

write.table(temp[,c(1,2,3,7,8,6)], file="outfile.txt", quote=FALSE, 
            row.names=FALSE, col.names=FALSE, sep="\t")
