#!/bin/bash
set -e


zcat < luscinia_vars.vcf.gz | grep -v '^#' | cut -f6,8 |awk 'BEGIN{OFS="\t"}{split($2,a,";");for(i in a) if(a[i] ~ /^DP=/) {sub("DP=","",a[i]); print $1, a[i]}}' > 3_attempt_output_for_R.tsv

