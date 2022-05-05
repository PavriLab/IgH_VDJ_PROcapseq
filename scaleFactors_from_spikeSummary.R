#!/usr/bin/env Rscript
library(tidyverse)

# modified from https://github.com/fruce-ki/utility_scripts/raw/master/scaleFactors_from_spikeSummary.R

args <- commandArgs(trailingOnly=TRUE)
# args <- c('/Volumes/groups/zuber/zubarchive/USERS/Kimon/jakub/M11914_slamseq/process/slamdeep/spike_summary_counts.txt', '21')

files = Sys.glob("out/*.counts.txt")
tags = gsub(".counts.txt","",gsub("out/","",files))
DT = tibble()
for(i in 1:length(tags)) {
	z = unique(read.table(files[[i]],header=T))
	z = filter(z, Stage %in% c("_locus","_subject","_spikein","_ambiguous")) %>% mutate(Reads = as.integer(Reads))
	z$tag = tags[[i]]
	DT = bind_rows(DT, z)
}

# Presumes the following columns (from my Split_BAM_Spikein.py script): row_ID, ambiguous_counts, spike_counts, subject_counts
DT = mutate(DT, Stage=gsub("^_","", Stage)) %>% spread(Stage, Reads)


# Spike-in to subject ratio in each pooled sample.
DT["ratio"] <- DT$spikein / DT$subject

###
### Method focusing on the how the reads ratio changes between spike-in and subject, after a global fold-change in the subject.
###
##
## For an unperturbed reference sample:
##
##   Dk (spikein reads)    Nk (spikein nuclei)  *  Rk (RNA per spikein nucleus)
##   -----------------  =  ----------------------------------------------------
##   Dj (subjet reads)     Nj (subject nuclei)  *  Rj (RNA per subject nucleus)
##
## For a perturbed sample with global expression shift by a factor f: (new Rj) = f * (reference Rj), while maintaining the same ratio of nuclei:
##
##   Ek (spikein reads)    Nk (spikein nuclei)  *  Rk (RNA per spikein nucleus)                                    1    Nk * Rk      1    Dk
##   -----------------  =  ------------------------------------------------------------------------------      =  --- * -------  =  --- * --
##   Ej (subjet reads)     Nj (subject nuclei)  *  [f (perturbation) * Rj (RNA per reference subject nucleus)]     f    Nj * Rj      f    Dj
##
## Solving for f:
##
##        Dk   Ej
##  f  =  -- * --
##        Dj   Ek
##

# Assign a reference sample.
if (is.na(args[2])) {
	# Picking the min ratio means all scaling will be downwards. This is conservative, but vulnerable to samples with very poor library sizes.
	ref <- which(DT$ratio == min(DT$ratio))[1]   # Only min or max. Median is not guaranteed to be an existing value if number of rows is even.
	# And I do need the reference to be one from the table, so as to have a matched pair of spike-in and subject.
} else {
	ref <- as.integer(args[2])
	# TODO: Expand to create the reference pair by averaging the respective counts across multiple reference samples.
}

ratio_val = DT[[ref, "ratio"]]

# Perturbation is the global expression shift of one subject relative to the reference subject.
## perturbed expression = factor * reference expression
# The perturbation factor is calculated from the read ratios with the formula derived above.
# TODO: Expand to create the reference pair by averaging the respective counts across multiple reference samples.
#DT["subject_perturbation"] <- (DT[ref, "spikein"] / DT[ref, "subject"]) * (DT$subject / DT$spikein)
DT = mutate(DT, subject_perturbation=(ratio_val * (subject / spikein)))

# The perturbation factor is defined relative to the reference sample. So that's the base value from which to extrapolate the others.
DT["normalized_subject_counts"] <- DT[[ref, "subject"]] * DT$subject_perturbation

# And now the scaling factor from the original subject counts to the spike-in adjusted ones. 
# These are the factors to apply to gene expressions to achieve spike-in normalization.
## raw_count * factor = normalized_count
## factor = normalized_count / raw_count
DT["subject_factor"] <- DT$normalized_subject_counts / DT$subject

DT = mutate(DT, locus_factor=1e6/locus)

select(DT, tag, subject_factor) %>% write_tsv(file='out/spikein_factors.txt')

select(DT, tag, locus_factor) %>% write_tsv(file='out/locus_factors.txt')

#write.table(DT[, c("row_ID", "subject_factor")], file=sub('txt|csv|tsv', 'factors.txt', args[1], perl=TRUE), sep="\t", quote=FALSE, row.names=FALSE, col.names=TRUE)
#write.table(DT, file=args[1], sep="\t", quote=FALSE, row.names=FALSE, col.names=TRUE)


