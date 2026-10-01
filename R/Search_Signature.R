#' Search_Signature
#'
#' @param signature Name of the signature.
#' @param organsim Name of the organsim
#' @param method Name of the method
#' @return Vector of corresponding signatures.
#' @export
Search_Signature <- function(signature = c("all"),
                             organsim = c("all"),
                             method = c("all")) {
  df <- MelaSigDB::Metadata_Sig

  stopifnot(is.character(signature),
            is.character(organsim),
            is.character(method))

  signature_lower <- as.vector(tolower(signature))
  organsim_lower <- as.vector(tolower(organsim))
  method_lower <- as.vector(tolower(method))

  target_signature <- c()
  for (y in seq_along(signature_lower)) {
    for (i in seq_along(df$signature_id)) {
      if ((grepl(signature_lower[y], tolower(df$signature_id[i]), fixed = FALSE)) == TRUE) {
        target_signature <- c(df$signature_id[i], target_signature)
      }
    }
    if ((grepl(signature_lower[y], "all", fixed = FALSE)) == TRUE) {
      print("all signatures")
      target_signature <- df$signature_id
    }
    if (length(target_signature) == 0) {
      print("no signature detected, default is all signatures")
      target_signature <- df$signature_id
    }
  }

  target_organism <- c()
  for (y in seq_along(organsim_lower)) {
    for (i in seq_along(df$organism)) {
      if ((grepl(organsim_lower[y], tolower(df$organism[i]), fixed = FALSE)) == TRUE) {
        target_organism <- c(df$signature_id[i], target_organism)
      }
    }
    if ((grepl(organsim_lower[y], "all", fixed = FALSE)) == TRUE) {
      print("all organism")
      target_organism <- df$signature_id
    }
    if (length(target_signature) == 0) {
      print("no organism detected, default is all")
      target_organism <- df$signature_id
    }
  }
  target_method <- c()
  for (y in seq_along(method_lower)) {
    for (i in seq_along(df$method)) {
      if ((grepl(method_lower[y], tolower(df$method[i]), fixed = FALSE)) == TRUE) {
        target_method <- c(df$signature_id[i], target_method)
      }
    }
    if ((grepl(method_lower[y], "all", fixed = FALSE)) == TRUE) {
      print("all methods")
      target_method <- df$signature_id
    }
    if (length(target_signature) == 0) {
      print("no method detected, default is all")
      target_method <- df$signature_id
    }
  }

  target_final <- intersect(target_method, target_organism)
  target_final <- intersect(target_signature, target_final)

  return(target_final)
}
