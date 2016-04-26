

library(qgraph)
# Load big5 dataset:
data(big5)
data(big5groups)

# Correlations:
Q <- qgraph(cor(big5), minimum = 0.25, cut = 0.4, vsize = 1.5, groups = big5groups, 
            legend = TRUE, borders = FALSE)
title("Big 5 correlations", line = 2.5)


# Same graph with spring layout:
Q <- qgraph(Q, layout = "spring")
title("Big 5 correlations", line = 2.5)

qgraph(Q, overlay = TRUE)
title("Big 5 correlations", line = 2.5)

qgraph(Q, posCol = "blue", negCol = "purple")
title("Big 5 correlations", line = 2.5)


# Significance graph (circular):
qgraph(cor(big5), graph = "sig", groups = big5groups, layout = "circular")
title("Big 5 correlations (p-values)", line = 2.5)

# Significance graph (distinguishing positive and negative statistics):
qgraph(cor(big5),  minimum = 0.25, cut = 0.4, vsize = 1.5, groups = big5groupsgraph,layout ="sig2")
title("Big 5 correlations (p-values)", line = 2.5)


data(big5)
data(big5groups)

qgraph.panel(cor(big5), groups = big5groups, minimum = 0.2, borders = FALSE, 
             vsize = 1, cut = 0.3)

#Shortest path
set.seed(1)
adj <- matrix(sample(0:1, 10^2, TRUE, prob = c(0.8, 0.2)), nrow = 10, ncol = 10)
Q <- qgraph(adj)
centrality(Q)
