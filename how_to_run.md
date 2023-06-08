Instructions for PRO-seq and PRO-cap analyses

### 1. System requirements

The pipelines are designed to run on a HPC cluster with Linux operating system and SLURM workload manager: https://slurm.schedmd.com

### 2. Installation guide

The pipelines software dependencies can be installed with conda:

1. install conda with the bioconda channel: https://bioconda.github.io/

2. create a new env with the required packages:

`conda create -n igh_pipe bc umi_tools r-data.table fastqc multiqc cutadapt trimmomatic bowtie bedtools samtools ucsc-bedgraphtobigwig ucsc-bigwigtobedgraph pysam pandas intervaltree pybedtools ucsc-bedsort bowtie2 flash r-patchwork python-levenshtein biopython r-matrixstats r-ggrepel`

4. clone the pipeline repository locally: https://github.com/PavriLab/IgH_VDJ_PROcapseq 

### 3. Instructions for use

Overview of the pipeline: [IgH_Pipeline.pptx](IgH_Pipeline.pptx)

Before running the pipeline, it is necessary to define which reference will be used to align the reads. The repositories contain all the references used for the analyses in the paper on the `reference_and_annotation` folder.

The pipeline is run with the bash script `igh_workflow.sh` contained within the code repository. Assuming the input BAM is named `input.bam`, run the following command:
```bash
REF=B18
protype=proseq # either procap or proseq
umi_length=8
input_bam=input.bam
bash igh_workflow.sh -1 -2 -3 -4 -5 -i $input_bam -o out -L $REF -t $protype -k -n $umi_length
```

The output files will be stored in the `out/tracks` directory.

See also: [NOTES.md](NOTES.md)