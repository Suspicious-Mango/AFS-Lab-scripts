require(tidyverse)
require(ggplot2)

df = fread("in-file.txt", header = FALSE, sep = "\t")

plot = ggplot(data = df) +
  geom_col(mapping = aes(x = Strain, y = Count, fill = TE_type)) +
  facet_wrap(~ LTR_type) +
  scale_x_discrete(limits = c("129S1_SvImJ", "A_J", "AKR_J",
                              "BALB_cJ", "C3H_HeJ", "C57BL_6NJ",
                              "CBA_J", "DBA_2J", "FVB_NJ", "LP_J",
                              "NOD_ShiLtJ", "NZO_HlLtJ", "WSB_EiJ",
                              "JF1_MsJ", "CAST_EiJ", "PWK_PhJ"),
                              "SPRET_EiJ"),
                   labels = c("129", "A_J", "AKR",
                            "BALB", "C3H", "BL_6",
                            "CBA", "DBA", "FVB", "LP",
                            "NOD", "NZO", "WSB",
                            "JF1", "CAST", "PWK")) +
                            "SPRET")) +
  theme_bw() +
  scale_fill_discrete(name = "TE Type",
                      limits = c("1delta1", "full", "solo"),
                      labels = c("Id1 IAPs", "Full IAPs (non-Id1)", "Solo LTRs")) +
  theme(axis.ticks = element_blank(),
        legend.background = element_rect(fill = "lightgray"),
        legend.position = "top") +
  labs(fill = "TE Type", y = "Counts") +
  coord_flip()

  ggsave("outfile.png", plot)