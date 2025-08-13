suppressMessages(require(data.table))
suppressMessages(require(ggplot2))
suppressMessages(require(tidyr))
suppressMessages(require(tidyverse))

#in-file is a file with the phylogeny ID's in the first column and which catagory it is in for the second column 
#see 1d1-pop_alpha-barchart.sh for generation
data <- fread("in-file.txt", header=FALSE, col.names = c("strain", "cat")) %>%
    mutate(strain = substr(strain, 1, 3)) #splicing out the ID number so it is only the strain name

#color coding: p1 = population alpha, np1 = non-population alpha, 1d1 = 1d1 associated, n1d1 = not 1d1 associated
cat_fill = c("p1-1d1" = "darkviolet", "p1-n1d1" = "deepskyblue2", "np1-1d1" = "coral2", "np1-n1d1" = "grey") 

barchart <- ggplot(data, aes(x = strain)) +
    geom_bar(aes(fill = cat)) + #fill = category
    labs(title = expression(paste("Population ", alpha, " and Id1 Proportion in LTR1s Across Strains")),
         x = "Strains",
         y = "Count") +
    scale_fill_manual(values = cat_fill,
                      labels = c("Id1", "Neither", expression(paste(alpha, " + Id1")), expression(alpha)),
                      name = "Classification") + #legend
    scale_x_discrete(labels = c("Bl6", "CAST", "JF1", "PWK", "SPRET")) #renaming strains for graph

#saving image in cwd
ggsave("pop_alpha-Id1-barchart.png", barchart, device = "png", height = 6, width = 8)
