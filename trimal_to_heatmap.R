suppressMessages(require(data.table))
suppressMessages(require(tidyverse))
suppressMessages(require(tidyr))

name = commandArgs(trailingOnly=TRUE)
if (length(name)==0 | length(name)>1) {
  stop("One argument must be supplied (input file).n", call.=FALSE)
}

trimal <- fread("in-file.txt", header = FALSE, stringsAsFactors=FALSE) %>%
    mutate(V2 = "")

cut.vec = c()

i = 1
while (i < nrow(trimal)) { #iterate down rows
    if (grepl(">", trimal[i,1])){ #if row is beginning of new sequence (ex. >SPR_1)
        for (j in i+1:nrow(trimal)){ #iterate until next sequence (ex. >SPR_2)
           trimal[i, 2] = paste0(trimal[i, 2], trimal[j, 1]) #add sequence to column adjacent to new sequence designation 
            if (grepl(">", trimal[j+1,1]) | j == nrow(trimal)){
                i = j #jump iteration
                cut.vec = append(cut.vec, j) #add row to be cut
                break
            }
            cut.vec = append(cut.vec, j) #add rows to be cut
        }
    }
    i = i + 1 #iterate
}

trimal <- trimal[-cut.vec,] %>% #cut rows with redundant sequences
    mutate(V1 = sub('.', '', V1)) %>% #remove the first character (">") in sequence designations
    separate(V2, paste0("V", 2:nchar(trimal[1, 2])), sep = 1:nchar(trimal[1,2])) #splits sequence column into columns of individual NTs
    

filename = paste0("msa-", name)

write.table(trimal, file=paste0(filename, ".txt"), quote=FALSE,
            row.names=FALSE, col.names=FALSE, sep="\t")