# Notes about the pipeline

## Job waiting

`wait_for_jobs` will wait for jobs under my user name *only*. Anyone else using the workflow script would have to update the username that the function looks for. Be aware that usernames in the `squeue` output are truncated, you will need the truncated value for the function.

## Presets

`-L` controls multiple presets.

* In `igh_workflow.sh`, `GENOME` and `CELLINE` determine which bowtie index to use from within the `INDEXDIR`. 
Index names must be structured as `GENOME_plus_CELLLINE`, as the filepaths are procedurally assembled during runtime. 
`CELLLINE` is also the name of the VDJ sequence "chromosome".
Chromosome lengths in `CHRINFO` are needed for genome browser track creation.

* In `DiscardNonIgHReads.py` the genomic IgH chromosome and coordinate range for each genome are defined.

## Spike ins

`-k` switches the bowtie index used in each case of `-L`, by leveraging the structured names of indices. 

* Indices for spiked-in runs are separate from those without spikeins. 
Index names must be structured as `GENOME_plus_dmr6_plus_CELLLINE` and should be in the same `INDEXDIR`, , as the filepaths are procedurally assembled during runtime.

* Evidently, Drosophila melanogaster is expected to be the spikein genome used, and dmr6 is the genome assembly I used for it.
In `SplitSpikein.py` a list is defined with all the chromosome names that belong to the spike-in genome.
