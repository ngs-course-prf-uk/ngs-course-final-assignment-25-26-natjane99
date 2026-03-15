library(tidyverse)
read_tsv('3_attempt_output_for_R.tsv') -> d

head(d)
tail(d)

d <- read_tsv("3_attempt_output_for_R.tsv", col_names = c("QUAL", "DP"))
d2 <- d[d$QUAL < 900, ]
p <- ggplot(d2, aes(x = DP, y = QUAL)) + 
  geom_smooth(method = "lm", se = TRUE) +
  geom_point(alpha = 0.2, size = 0.8, color = "forestgreen") + 
  labs(title = "Correlation between PHRED quality (QUAL) and read depth (DP)", x = "DP", y = "QUAL")
print(p)

ggsave("testplot.jpg", plot = p, width = 8, height = 6, dpi = 300)
