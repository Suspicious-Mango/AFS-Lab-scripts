suppressMessages(require(data.table))
suppressMessages(require(tidyverse))

#supply IAPLTR type as argument (e.g. IAPLTR1_Mm or IAPLTR1a_Mm) in IAPLTR-counter.sh script
IAPLTR_type <- fread("../LTR_to_pull.txt", header = FALSE, stringsAsFactors=FALSE)

iapltr <- fread("in-file.txt", header = FALSE, 
                stringsAsFactors=FALSE, fill = TRUE) %>% #read in fasta.out
  filter(V10 %in% IAPLTR_type$V1 | V10 == "IAPEz-int") %>%  #pull out only elements of interest
  mutate(V9 = ifelse((V9 == "C"), "-", "+")) #swap "C" with "-" in strand column

cut.vec <- c()   #stores rows to cut by row index

solo_count = 1
full_1d1_count = 1
full_non1d1_count = 1
Id1_FLAG = FALSE

iapltr.all <- iapltr[,c(5,6,7,10,10,9)] #editable df. chrom, start, stop, IAPLTR, IAPLTR, strand

i = 1
leeway = 100  #100 bp gaps maximum rows to be considered sequential
while (i < nrow(iapltr)){
  if (iapltr[i,10] %in% IAPLTR_type$V1) { #if in passed in list (i.e. is an IAPLTR...)
    #if IAPLTR is the start of a full IAPLTR given the following conditions:
    if ((abs(as.numeric(iapltr[i+1,6]) - as.numeric(iapltr[i,7]))  <= leeway  #sequential segments are close together
         | as.numeric(iapltr[i+1,6]) < as.numeric(iapltr[i,7]))   #or overlap
        & iapltr[i+1,5] == iapltr[i,5] #and are on the same chromosome 
        & iapltr[i,15] == iapltr[i+1,15]){ #and are the same ID element  
      #passed full IAPLTR conditions
      for (j in seq(i+1, nrow(iapltr) - 1)){ #start moving down list until ID changes (end of full LTR)
        #testing for 1d1 deletion
        if ((iapltr[j,9] == "+") & #if positive strand
          (iapltr[j,9] == iapltr[j+1,9]) & #same strand
          (as.numeric(iapltr[j,13]) > 1308 & as.numeric(iapltr[j,13]) < 1318) & #within start pos range
          (as.numeric(iapltr[j+1,12]) > 3205 & as.numeric(iapltr[j+1,12]) < 3215)) { #within end pos range
            Id1_FLAG = TRUE
        } else if((iapltr[j,9] == "-") &  #antisense strand
          (iapltr[j,9] == iapltr[j+1,9]) & #same strand
          (as.numeric(iapltr[j+1,13]) > 1308 & as.numeric(iapltr[j+1,13]) < 1318) & #within start pos range
          (as.numeric(iapltr[j,14]) > 3205 & as.numeric(iapltr[j,14]) < 3215)) { #within end pos range
            Id1_FLAG = TRUE  
        }
        if ((as.numeric(iapltr[j,15]) != as.numeric(iapltr[j+1,15])) & #if ID change (end of full LTR)
            (iapltr[i,10] == iapltr[j, 10])){ #and start LTR is same type as end LTR
            iapltr.all[i,3] = iapltr.all[j,3] #set chromEnd value of start ltr as end ltr
            if (Id1_FLAG == TRUE){ #if a 1d1 deletion was found, add to 1d1 count. otherwise, add to non1d1 count
              iapltr.all[i,5] = paste0("Id1_", full_1d1_count)
              full_1d1_count = full_1d1_count + 1 
              Id1_FLAG = FALSE 
            } else {
              iapltr.all[i,5] = paste0("non1d1_", full_non1d1_count)
              full_non1d1_count = full_non1d1_count + 1
            }
            cut.vec <- append(cut.vec, j) #cuts final LTR bc info is saved on first instance of TE in iapltr.all
            i = j     #jumps iteration ahead to end of full LTR
            break
        } else if (j >= nrow(iapltr) | j < 0){ #handles overflow
            break
        }
        cut.vec <- append(cut.vec, j) #add rows cycled to cut (are ez-ints)
      }
    } else { #if solo IAPLTR (IAPLTR without a subsequent IAPEz-int)
      iapltr.all[i,5] = paste0("s_", solo_count)
      solo_count = solo_count + 1
    }
    
  } else {  #ez-int
    cut.vec <- append(cut.vec, i)
  }
  i = i + 1  #iterate
}

iapltr.all <- iapltr.all[-cut.vec,] #cutting all irrelevant data and TE intermediates
colnames(iapltr.all) <- c("chr", "start", "stop", "LTR", "ID", "strand")
#now it is: chrom, start, stop, IAPLTR, solo/full/1d1, strand

#seperate each ID into it's own file
iapltr.solo <- iapltr.all %>% filter(str_detect(ID, 's_'))
iapltr.full <- iapltr.all %>% filter(str_detect(ID, 'd1'))
iapltr.1d1 <- iapltr.all %>% filter(str_detect(ID, 'Id1_'))
iapltr.non1d1 <- iapltr.all %>% filter(str_detect(ID, 'non1d1_'))

#saving
write.table(iapltr.all, file="outfile.all.txt", quote=FALSE,
            row.names=FALSE, col.names=FALSE, sep="\t")
write.table(iapltr.solo, file="outfile.solos.txt", quote=FALSE,
            row.names=FALSE, col.names=FALSE, sep="\t")
write.table(iapltr.full, file="outfile.fulls.txt", quote=FALSE,
            row.names=FALSE, col.names=FALSE, sep="\t")
write.table(iapltr.1d1, file="outfile.1d1.txt", quote=FALSE,
            row.names=FALSE, col.names=FALSE, sep="\t")
write.table(iapltr.non1d1, file="outfile.non1d1.txt", quote=FALSE,
            row.names=FALSE, col.names=FALSE, sep="\t")
