
this directory contains reference fastas utilized in the analysis.

the Hg38 genome was used but omitted to save space, it can be downloaded at:
https://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/

for example, to create a index:

1. contatenate Hg38 with the VDJ:
cat hg38.fa Ramos_IgH.fa > Hg38_plus_Ramos_IgH.fa

2. run bowtie-build:
bowtie-build Hg38_plus_Ramos_IgH.fa Hg38_plus_Ramos_IgH


