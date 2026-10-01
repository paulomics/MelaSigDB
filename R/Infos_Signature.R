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

  vec_signatures <- Search_Signature(
    signature = signature,
    organsim = organsim,
    method = method
  )

  vec_references <- unique(
    Metadata_Sig$reference[
      Metadata_Sig$signature_id %in% vec_signatures
    ]
  )
  vec_references <- na.omit(vec_references)

  ref_dir <- system.file(
    "extdata/reference",
    package = "MelaSigDB"
  )

  df_bib <- lapply(vec_references, function(ref) {
    RefManageR::ReadBib(
      file.path(ref_dir, paste0(ref, ".bib"))
    )
  })

  names(df_bib) <- vec_references

  return(df_bib)
}
