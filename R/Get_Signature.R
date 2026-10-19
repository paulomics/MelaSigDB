#' Get_Signature
#'
#' @param signature Name of the signature.
#' @param organsim Name of the organsim
#' @param method Name of the method
#' @param organism_format Name of organism for the output gene format
#' @param gene_format Name of the gene format
#' @param output_format Name of the output format
#' @return Vector of genes associated with the signatures.
#' @export
Get_Signature <- function(signature = "all",
                          organsim = "all",
                          method = "all",
                          organism_format = "human",
                          gene_format = "symbol",
                          output_format = "data.frame") {
  vec_signatures <- Search_Signature(signature = signature,
                                     organsim = organsim,
                                     method = method)
  id1_format <- NA
  if (grepl(tolower(organism_format), "human", fixed = FALSE) == TRUE) {
    id1_format <- "HUMAN"
  }
  if ((grepl(tolower(organism_format), "mouse", fixed = FALSE)) == TRUE |
      (grepl(tolower(organism_format), "mice", fixed = FALSE)) == TRUE) {
    id1_format <- "MOUSE"
  }
  if (is.na(id1_format)) {
    stop("'organism_format' must be a string 'human' or 'mouse'.")
  }


  id2_format <- NA
  if ((grepl(tolower(gene_format), "ensembl_id", fixed = FALSE)) == TRUE) {
    id2_format <- "ENSEMBL"
  }
  if ((grepl(tolower(gene_format), "entrez_id", fixed = FALSE)) == TRUE) {
    id2_format <- "ENTREZ"
  }
  if ((grepl(tolower(gene_format), "symbol_id", fixed = FALSE)) == TRUE) {
    id2_format <- "SY"
  }
  if (is.na(id2_format)) {
    stop("'gene_format' must be a string 'symbol' or 'ensembl' or 'entrez'.")
  }

  id_format <- paste0(id1_format, "_", id2_format)

  MelSign_sets <- MelaSigDB::MelaSigDB
  MelSign_sets[] <- lapply(MelSign_sets, function(x) {
    if (is.character(x)) {
      x[trimws(x) %in% c("", "NA", "NULL")] <- NA
    }
    x
  })
  MelSign_sets <- MelSign_sets[MelSign_sets$SIGNATURE %in% vec_signatures, ]
  MelSign_sets <- subset(MelSign_sets, select = c("SIGNATURE", id_format))
  MelSign_sets <- MelSign_sets[!duplicated(MelSign_sets), ]
  MelSign_sets <- na.omit(MelSign_sets)

  if (!tolower(output_format) %in% c("data.frame",
                                     "dataframe",
                                     "df",
                                     "list",
                                     "named_vector",
                                     "vector",
                                     "namevector")) {
    MelSign_sets <- setNames(MelSign_sets[[id_format]], MelSign_sets$SIGNATURE)
    stop("'output_format' must be a string 'data.frame' or 'list' or 'vector'.")
  }

  if (tolower(output_format) %in% c("data.frame", "dataframe", "df")) {
    return(MelSign_sets)
  }

  if (tolower(output_format) %in% c("list")) {
    MelSign_sets <- split(MelSign_sets[[id_format]], MelSign_sets$SIGNATURE)
    return(MelSign_sets)
  }

  if (tolower(output_format) %in% c("named_vector", "namevector")) {
    MelSign_sets <- setNames(MelSign_sets[[id_format]], MelSign_sets$SIGNATURE)
    return(MelSign_sets)
  }
  if (tolower(output_format) %in% c("vector")) {
    MelSign_sets <-unique(na.omit(MelSign_sets[[id_format]]))
    return(MelSign_sets)
  }
}
