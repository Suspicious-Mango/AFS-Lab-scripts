suppressMessages(require(treeio))
suppressMessages(require(ggtree))
suppressMessages(require(tidytree))
suppressMessages(require(data.table))
suppressMessages(require(ggplot2))
suppressMessages(require(aplot))
suppressMessages(require(reshape))
suppressMessages(require(tidyr))
suppressMessages(require(ggplotify))

name = commandArgs(trailingOnly=TRUE) #read in the name for the plot title
if (length(name)==0 | length(name)>1) {
  stop("One argument must be supplied (input file).n", call.=FALSE)
} 

treefile = read.newick("in-tree.txt") #phylip_tree

#fastafile = "in-fasta.txt"

#color code
NT_colors = c("a" = "chartreuse2", "t" = "coral2", "c" = "deepskyblue1", "g" = "darkgoldenrod2", "-" = "white")

treeplot = treefile %>% ggtree() + #generate tree
	theme_tree2() +
	labs(title = name, 
		 subtitle = "IAPLTR1 clustering and sequence alignment")

#duoplot = msaplot(treeplot, fastafile, bg_line = FALSE, color = NT_colors) + #generate msa + tree plot
#	labs(fill = "Sequence") #+ geom_tiplab()	


ggsave("outfile.png", treeplot, device = "png", height = 8, width = 12) #saving
