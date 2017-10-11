# bamreadcountr
wrapper and parses for bam readcount

tl;dr


```
x='/rsrch2/iacs/ngs_runs/1411_sarcomatoid/tmap/bams/tmp.bamreadcount'

bed has columns:
chr start end ref_allele  alt_allele

# parse the output with:
bam_readcount.parse(x, samplename = "sample1", bed)
```
