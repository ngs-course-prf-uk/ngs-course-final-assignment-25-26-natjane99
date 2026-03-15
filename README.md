[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/SzF8zjrH)
# Unix Course Final Assignment
This is a template repository for the Unix course final assignment. You should use this template to submit your solution to the final assignment.

Put your shell code in `workflow.sh` and the R code to visualise results in `data-analysis.R`.

This repository contains a solution to the task 9
**Correlation between PHRED quality (QUAL) and real depth (DP)**

The input file from which the analysis whas done:

*luscinia_vars.vcf.gz*

workflow.sh contains the code needed for the extraction of wanted values
data-analysis.R contains the R script used to plot the data into a scatter plot

workflow.sh code:
```
#to specify we are running in bash, set -e kills the script if command fails
#!/bin/bash
set -e

#first we want to copy the dataset into our working directory
cp /data-shared/vcf_examples/luscinia_vars.vcf.gz .

#we check the formatting of the dataset and find our values of interest: they are in column 6,8
zcat luscinia_vars.vcf.gz | tail

#we get rid of the header lines
zcat luscinia_vars.vcf.gz | grep -v '^#' | head

#we separate our columns of interest
zcat luscinia_vars.vcf.gz | grep -v '^#' | cut -f6,8 | head

#here we had to use awk to separate/parse the DP values from the INFO
#they were not always in the same position, so for loop was used
zcat < luscinia_vars.vcf.gz | grep -v '^#' | cut -f6,8 |awk 'BEGIN{OFS="\t"}{split($2,a,";");for(i in a) if(a[i] ~ /^DP=/) {sub("DP=","",a[i]); print $1, a[i]}}'| head

#save it into an output file
same as in the beginning= | cut -f6,8 |awk 'BEGIN{OFS="\t"}{split($2,a,";");for(i in a) if(a[i] ~ /^DP=/) {sub("DP=","",a[i]); print $1, a[i]}}' > 3_attempt_output_for_R.tsv

```
To run the workflow.sh, run:
```
chmod +x workflow.sh
./workflow.sh
```
A file called "3_attempt_output_for_R.tsv" should be created.


What is in the graph?

The graph shows the relationship between read depth (DP) and PHRED quality (QUAL) for the variants extracted from the VCF file.
Values above 900 were removed from the plotting, so that the general behavior can be seen properly.


![Correlation Plot: DP & QUAL](you_power_is_GREEN.jpeg)

```r
library(tidyverse)

#read the processed data
d <- read_tsv("3_attempt_output_for_R.tsv", col_names = c("QUAL", "DP"))

#filter extremely high QUAL values for better plotting
d2 <- d[d$QUAL < 900, ]

#create the plot
p <- ggplot(d2, aes(x = DP, y = QUAL)) + 
  geom_smooth(method = "lm", se = TRUE) +
  geom_point(alpha = 0.2, size = 0.8, color = "forestgreen") + 
  labs(title = "Correlation between PHRED quality (QUAL) and read depth (DP)", x = "DP", y = "QUAL")
print(p)

#you can also save the plot here, i saved it in R studio
ggsave("testplot.jpeg", plot = p, width = 8, height = 6, dpi = 300)
```
To run the R script, run:
```
Rscript data-analysis.R
```

What are the results?

The final plot shows how PHRED quality changes with read depth across the detected variants. 
A linear regression line shows the general trend. There is a slight positive relationship between DP and Qual.
However, the relationship looks weak. The points are very widely scattered. Most variants are concentrated at low DP and low QUAL - the graph gets very dense.

![Correlation Plot: DP & QUAL](you_power_is_GREEN.jpeg)
