suppressMessages(require(data.table))
suppressMessages(require(ggplot2))
suppressMessages(require(tidyr))
suppressMessages(require(tidyverse))

data <- fread("in-file.txt", header=FALSE, col.names = c("strain", "cat")) %>%
    mutate(strain = substr(strain, 1, 3)) #splicing only strain name

cat_fill = c("p1-1d1" = "darkviolet", "p1-n1d1" = "deepskyblue2", "np1-1d1" = "coral2", "np1-n1d1" = "grey") 

barchart <- ggplot(data, aes(x = strain)) +
    geom_bar(aes(fill = cat)) +
    labs(title = expression(paste("Population ", alpha, " and Id1 Proportion in LTR1s Across Strains")),
         x = "Strains",
         y = "Count") +
    scale_fill_manual(values = cat_fill,
                      labels = c("Id1", "Neither", expression(paste(alpha, " + Id1")), expression(alpha)),
                      name = "Classification") +
    scale_x_discrete(labels = c("Bl6", "CAST", "JF1", "PWK", "SPRET"))

ggsave("pop_alpha-Id1-barchart.png", barchart, device = "png", height = 6, width = 8)
