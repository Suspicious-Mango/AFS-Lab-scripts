suppressMessages(require(treeio))
suppressMessages(require(ggtree))
suppressMessages(require(tidytree))
suppressMessages(require(data.table))
suppressMessages(require(ggplot2))
suppressMessages(require(aplot))
suppressMessages(require(reshape))
suppressMessages(require(tidyr))
suppressMessages(require(ggplotify))

# This script is used to generate a tree plot with a multiple sequence alignment and an Id1 matrix
# for a subset of mouse strains, specifically the IAPLTR1 elements.
name = commandArgs(trailingOnly=TRUE)
if (length(name)==0 | length(name)>1) {
  stop("One argument must be supplied (input file).n", call.=FALSE)
}
# Read in the tree, fasta, and Id1 matrix files
treefile = read.newick("in-tree.txt") 

fastafile = fread("in-fasta.txt", header = FALSE, sep="\t", stringsAsFactors = FALSE) %>%
	melt(id.vars = "V1") #mutates the data to long format for ggplot geom_tile
colnames(fastafile) <- c("label", "position", "nt")
fastafile = fastafile %>% replace_na(list(nt = '-'))

Id1file = fread("in-Id1_matrix.txt", header = FALSE, sep="\t") %>%
	filter(V2 == 1)

# Convert nucleotide characters to colors for plotting
NT_colors = c("a" = "chartreuse2", "t" = "coral2", "c" = "deepskyblue1", "g" = "darkgoldenrod2", "-" = "white")

# Subset the tree to focus on a specific node (PWK_222) and its descendants
#sub = treefile %>% tree_subset(node = 'PWK_222', levels_back=5) #found by trial and error
#write.table(sub$tip.label, file="windowed_tiplabs.txt", quote = FALSE, row.names=FALSE) #saves tip labels and removes quotation marks

# Generate the tree plot with color-coded tips for each mouse strain
treeplot = treefile %>% ggtree() + 
	geom_tippoint(mapping = aes(color = substr(label, 1, 3)), size = 1, alpha = 0.75) + 
	scale_color_manual(values = c("darkcyan", "goldenrod", "darkgreen", "brown3", "darkorchid3"), 
					   breaks = c("C57", "JF1", "CAS", "PWK", "SPR"), 
					   labels = c("domesticus (Bl6)", "molossinus (JF1)", "castaneus (CAST)", "musculus (PWK)", "spretus (SPRET)"),
					   name = "Strain",
					   guide = guide_legend(override.aes = list(size = 2.5))) +
	theme_tree2() +
	coord_cartesian(ylim = c(0, 400)) +
	#expand_limits(y = 3700) +
	facet_grid(. ~ "Tree") #adds the grey box label to the top of the plot

# Generate the multiple sequence alignment plot
msaplot = ggplot(fastafile, aes(x = position, y = label)) + 
	geom_tile(aes(fill = nt)) +
	scale_fill_manual(values = NT_colors,
					  name = "Sequence") + 
	theme_tree2() + coord_cartesian(ylim = c(0, 400)) +
	theme(axis.title.x = element_blank(), axis.text.x = element_blank(), axis.ticks.x = element_blank(),
		  axis.title.y = element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank()) + #removses axis labels and ticks
	#expand_limits(y = 3700) +
	facet_grid(. ~ "MSA")

# Generate the Id1 matrix plot
Id1plot = ggplot(Id1file, aes(x = V2, y = V1, fill = V2)) + 
	geom_tile() +
	theme_tree2() + coord_cartesian(ylim = c(0, 400)) +
	theme(axis.title.x = element_blank(), axis.text.x = element_blank(), axis.ticks.x = element_blank(),
		  axis.title.y = element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank(),
		  legend.position = "none") + #removes legend for Id1 matrix
	#expand_limits(y = 3700) +
	facet_grid(. ~ "Id1")

# Combine the plots into a single figure
comboplot = msaplot %>% insert_left(treeplot) %>% insert_right(Id1plot, width = 0.2) %>% 
	as.ggplot() + 
	labs(title = "Mouse Subspecies: IAPLTR1 clustering and Mulitple Sequence Alignment",
		 tag = expression(lambda)) +
	theme(plot.title = element_text(size = 18, hjust = 0.15))

ggsave("LTR_phylogeny-all_subspecies-lambda.png", comboplot, device = "png", height = 8, width = 16)

#windows used for subpopulations: lambda = 0, 400 ; gamma = 400, 2600 ; beta = 2600, 3150 ; alpha = 3150 , 3650