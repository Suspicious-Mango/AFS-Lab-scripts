require(tidyverse)
require(seqinr)
require(data.table)

#reads in a bed6
temp = fread("in-file.txt", fill=TRUE)|>
  na.omit()
indexes_to_cut = c() #empty vector to store ID's not associated with full TE's

i = 1

while(i < nrow(temp)-1){ #loops ID from start to end
  if(isTRUE((identical(temp[i,4],temp[i+1,4])) & #same strand
     (identical(temp[i,6],temp[i+1,6])) & #same ID
     (temp[i,3][1] - temp[i+1,2][1] < 25) & #same strand break within 50bp tol
     (identical(temp[i,1],temp[i+1,1]))) == TRUE){ #same chr
    for (j in i+1:nrow(temp)-1) { #cycle to end of TE ID
      if (!identical(temp[i,6],temp[j,6])){ #once ID changes
        temp[i,3] = temp[j,3] #set new end points
        indexes_to_cut = append(indexes_to_cut, i+1:j-1) #record middle to cut later
        i = j #jump iter for next ID
	break
      }
    }
  }
i = i + 1
}

temp = temp[-indexes_to_cut,] #removing ID's not associated with full TE's
write.table(temp, file="outfile.txt", quote=FALSE, 
            row.names=FALSE, col.names=FALSE, sep="\t") #saving
