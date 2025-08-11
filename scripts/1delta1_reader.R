require(tidyverse)
require(seqinr)
require(data.table)

temp = fread("in-file.txt", fill=16) |> #read in file
  filter(V10 == "IAPEz-int") |>
  na.omit()
ids_to_save = c()

for(i in 1:(nrow(temp)-1)){
  if((temp[i,9] == "+") & #positive strand
    (temp[i,9] == temp[i+1,9]) & #same strand
    (temp[i,13] > 1308 & temp[i,13] < 1318) & #within start pos range
    (temp[i+1,12] > 3205 & temp[i+1,12] < 3215) & #within end pos range
    (temp[i,15] == temp[i+1,15])){ #same ID
      ids_to_save = append(ids_to_save, as.numeric(temp[i,15]))
  }else if((temp[i,9] == "C") &  #antisense strand
    (temp[i,9] == temp[i+1,9]) & #same strand
    (temp[i+1,13] > 1308 & temp[i+1,13] < 1318) & #within start pos range
    (temp[i,14] > 3205 & temp[i,14] < 3215) & #within end pos range
    (temp[i,15] == temp[i+1,15])){ #same ID
      ids_to_save = append(ids_to_save, as.numeric(temp[i,15]))
  }
}

out.file = temp |> filter(V15 %in% ids_to_save) #return out.file as temp.txt
write.table(out.file, file="temp.txt", quote=FALSE,
            row.names=FALSE, col.names=FALSE, sep="\t")
