#' Title
#'
#' @param x 
#'
#' @return
#' @export
#'
#' @examples
bam_readcount.parseline <- function(x){
  cols = "base:count:avg_mapping_quality:avg_basequality:avg_se_mapping_quality:num_plus_strand:num_minus_strand:avg_pos_as_fraction:avg_num_mismatches_as_fraction:avg_sum_mismatch_qualities:num_q2_containing_reads:avg_distance_to_q2_start_in_q2_reads:avg_clipped_length:avg_distance_to_effective_3p_end"
  cols = strsplit(cols, ":")[[1]]
  
  # split line
  rw = strsplit(x, split = "\t")[[1]]
  
  # split each base counts
  tmp <- lapply(rw[-c(1:4)], function(bc){
    bc = strsplit(bc, split = ":")[[1]]
  }) %>% do.call(rbind, .)
  
  colnames(tmp) = cols
  
  dat = data.frame(chr = rw[1], pos = rw[2], 
                   ref = rw[3], dp = rw[4],
                   tmp)
  
}



# chr	position	reference_base	depth	base:count:avg_mapping_quality:avg_basequality:avg_se_mapping_quality:num_plus_strand:num_minus_strand:avg_pos_as_fraction:avg_num_mismatches_as_fraction:avg_sum_mismatch_qualities:num_q2_containing_reads:avg_distance_to_q2_start_in_q2_reads:avg_clipped_length:avg_distance_to_effective_3p_end   ...
#x='/rsrch2/iacs/ngs_runs/1411_sarcomatoid/tmap/bams/tmp.bamreadcount'
bam_readcount.parse <- function(x, 
                                samplename,
                                bed){
  
  library(params)
  library(dplyr)
  
  tmp = scan(x, what = "character", sep = "\n")
  
  dat = lapply(tmp, bam_readcount.parseline) %>% bind_rows()
  dat2 = select(dat, chr, start = pos, ref_allele = ref, alt_allele = base, alt_count = count) %>% 
    mutate(start = as.integer(start), 
           end = start, 
           alt_count = as.integer(alt_count), 
           samplename = samplename) %>% 
    group_by(chr, start) %>% 
    mutate(dp = sum(alt_count), 
           af = alt_count / dp) %>% 
    ungroup()
  
  # add ref counts
  dat_ref = select(dat2, chr, start, ref_allele, alt_allele, alt_count) %>% 
    filter(ref_allele == alt_allele) %>% mutate(ref_count = alt_count) %>% 
    select(-alt_count, -ref_allele, -alt_allele)
  
  dat2 = left_join(dat2, dat_ref, by = c("chr", "start"))
  
  # combine with bed
  if(!is.data.frame(bed))
    if(file.exists(bed))
      bed = read_tsv(bed)
  
  dat3 = left_join(bed, dat2, by = c("chr", "start", "end", 
                                     "ref_allele", "alt_allele"))
  

}
