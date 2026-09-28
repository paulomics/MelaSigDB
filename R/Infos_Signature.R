#' Infos_Signature
#'
#' @param signature Name of the signature.
#' @param organsim Name of the organsim
#' @param method Name of the method
#' @return Reference for each sigantures called.
#' @export

Infos_Signature <- function(signature = "all",
                            organsim = "all",
                            method = "all") {
  vec_signatures <- Search_Signature(signature = signature,
                                     organsim = organsim,
                                     method = method)
  df <- MelaSigDB::Metadata_Sig
  vec_references <- unique(df[df$signature_id %in% vec_signatures, ]$reference)

  df_bib <- list()
  for (i in seq_along(vec_references)) {
    ref_dir <- system.file("extdata/reference", package = "MelaSigDB")
    path_sig <- paste0(ref_dir, vec_references[i], ".bib")
    bib_tmp <- RefManageR::ReadBib(path_sig)
    df_bib <- list(df_bib, bib_tmp)
  }
  return(bib_tmp)
}

