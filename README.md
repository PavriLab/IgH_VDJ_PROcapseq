# IgH_VDJ_PROcapseq

This pipeline aligns PROcap or PROseq reads from an amplicon around a fixed VDJ sequence to a full reference genome to which the amplicon of the fixed VDJ has been added as an extra chromosome. Multimappers are allowed. As the cell lines only have the given fixed VDJ sequence and not the full cassette of Vs, Ds and Js, reads multimapping to those regions and the amplicon are identified and disambiguated as belonging to the amplicon.
There are provisions for optional use of UMIs for PCR deduplication and/or spike-in nuclei for global transcription assessment.

The pipeline is structured as modules, each with its own Bash script executing the relevant tools, with a central Bash script that executes the modules.

Certain file paths and property values are hard-coded in the pipeline and/or its scripts and can be selected for a predefined set of VDJ contexts. New sets of predefined values will need to be created and added to the code in the relevant places for use with new VDJ contexts.

# Dependencies

Dependencies are assumed to be loaded into the eexecution environment in advance. No management of dependencies is built into the pipeline.

* HPC with SLURM scheduler
* python 3.6.7, with pandas, pysam, intervaltree, pybedtools
* R 3.5.1, with data.table
* fastqc 0.11.8
* multiqc 1.7
* cutadapt 2.5
* bowtie 1.2.3
* gzip/gunzip
* umi-tools 1.0.0
* samtools 1.9
* bedtools 2.29.0
* ENCODE kentUtils
