require(tidyverse)
require(data.table)
require(dplyr)
require(tidyr)

temp = fread("in-file.txt", header=FALSE) %>%
  mutate(V2 = "") #temp column to put sequence in
cut_vec = c()
i = 1

while(i < nrow(temp)-1){ #iter down cols
  if(grepl(">", temp[i,1])){ #if contains >
    temp[i,1] = substr(temp[i,1], 2, nchar(temp[i,1]))
    for (j in i+1:nrow(temp)){ #iterate starting from i
      if(grepl(">", temp[j,1])){ #if does contain > (new LTR)
        i = j - 1
        break
      } else { #if not new LTR
        temp[i, 2] = paste0(temp[i,2], temp[j,1]) #add sequence chunk to i,2
        cut_vec = append(cut_vec, j) #cut intermediate rows eventually
      }
    }
  }
  i = i + 1
}

temp = temp[-cut_vec,] %>% #cut intermediates
  #seperates sequence in col 2 into nchar columns of 1 NT each
  tidyr::separate(V2, paste0("V",2:nchar(temp[1,2])), sep = 1:nchar(temp[1,2]))# %>%
  #dplyr::mutate(across(-V1, ~ case_when(. == 'a' ~ 1,
  #                               . == 't' ~ 2,
  #                               . == 'c' ~ 3,
  #                               . == 'g' ~ 4,
  #                               . == '-' ~ 0)))

write.table(temp, file="outfile.txt", quote=FALSE, 
            row.names=FALSE, col.names=FALSE, sep="\t", na = '-')
