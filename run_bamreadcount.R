


# Usage: bam-readcount [OPTIONS] <bam_file> [region]
# Generate metrics for bam_file at single nucleotide positions.
# Example: bam-readcount -f ref.fa some.bam
# Available options:
#   -h [ --help ]                         produce this message
# -v [ --version ]                      output the version
# -q [ --min-mapping-quality ] arg (=0) minimum mapping quality of reads used
# for counting.
# -b [ --min-base-quality ] arg (=0)    minimum base quality at a position to
# use the read for counting.
# -d [ --max-count ] arg (=10000000)    max depth to avoid excessive memory
# usage.
# -l [ --site-list ] arg                file containing a list of regions to
# report readcounts within.
# -f [ --reference-fasta ] arg          reference sequence in the fasta format.
# -D [ --print-individual-mapq ] arg    report the mapping qualities as a comma
# separated list.
# -p [ --per-library ]                  report results by library.
# -w [ --max-warnings ] arg             maximum number of warnings of each type
# to emit. -1 gives an unlimited number.
# -i [ --insertion-centric ]            generate indel centric readcounts.
# Reads containing insertions will not be
# included in per-base counts


#' Run BAM readcount
#'
#' @param bam 
#' @param bed 
#' @param bamreadcount_exe 
#'
#' @return
#' @export
#'
#' @examples
bam_readcount <- function(bam, 
                          samplename,
                          bed,
                          outfile,
                          fa_fl = "~/ref/human/b37/fastas/Homo_sapiens_assembly19.fasta",
                          bamreadcount_exe = "bam-readcount"){
  
  
  # bam-readcount [OPTIONS] <bam_file> [region]
  cmd = glue("{bamreadcount_exe} -l {bed} -f {fa_fl} {bam} > {outfile}")
  
  #system(cmd)
  flowmat = to_flowmat(list(bamreadcount = cmd), samplename = samplename)
  
  ret = list(flowmat = flowmat)
  return(ret)
  
  
  
}

