suppressMessages(require(tidytree))
suppressMessages(require(data.table))
suppressMessages(require(ggplot2))
suppressMessages(require(reshape))
suppressMessages(require(tidyr))
suppressMessages(require(ggplotify))

data <- fread("all_subspecies-population-list.txt", header = FALSE, 
              stringsAsFactors = FALSE, col.names = c("Strain", "Population")) %>% #read in file and define column names for ggplot
    mutate(Strain = substr(Strain, 1, 3)) #cut out the numbers from IDs to only seperate data by strain

strain.labs <- c("BL6", "CAST", "JF1", "PWK", "SPRET")
names(strain.labs) <- c("C57", "CAS", "JF1", "PWK", "SPR") #name conversion for plot, facet_wrap messes up doing it the normal way with scale x manual

plot <- ggplot(data, aes(x = '')) + #placeholder for x since it's made into polar coordinates later
    geom_bar(aes(fill = Population)) +
    coord_polar("y", start=0) + #polar coords
    scale_fill_manual(values = c("lightblue", "salmon2", "lightgreen", "yellow2"),
                      labels = c(expression(alpha), expression(beta), expression(gamma), expression(lambda)),
                      breaks = c("alpha", "beta", "gamma", "lambda"),
                      name = "Population") + #legend
    facet_wrap( ~ Strain, ncol = 5, labeller = labeller(Strain = strain.labs)) + #wrapping with names from earlier
    theme(axis.text = element_blank(),
        axis.ticks = element_blank(),
        axis.title = element_blank(),
        panel.grid = element_blank()) + #getting rid of ugly background on pie charts
    labs(title = "Strain Proportions per Population")

ggsave("Pop-pie.png", plot) #save
