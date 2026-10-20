#' Infos_Signature
#'
#' @param signature character vector informing signature·s name·s, **see Infos_Signature**, to search in the metadata, doesn't have to be the exact names.
#' @param organsim character vector informing organism·s, **human and/or mouse**,rom which signature where made to search in the metadata.
#' @param method character vector informing method·s, **scrna, brna and/or microarray**, from which signature where made to search in the metadata.
#' @return Reference for each signatures called.
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
