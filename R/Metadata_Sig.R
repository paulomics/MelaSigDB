#' Metadata_Sig
#'
#' MelaSigDB metadata as a dataframe.
#'
#' @format A data frame with columns:
#' \describe{
#'   \item{signature_id}{Signature code name.}
#'   \item{collection}{Bibliographic collection source of the signature.}
#'   \item{target_phenotype}{Melanoma phenotype enlightened by the signature (not used).}
#'   \item{signature_short_name}{Short name of the signature.}
#'   \item{signature_publication_name}{Publication-friendly name of the signature.}
#'   \item{reference}{Reference ID of the signature.}
#'   \item{method}{Transcriptomic method used to generate the signature.}
#'   \item{organism}{Organism from which the signature was derived.}
#'   \item{ranking}{Gene ranking method used to order the genes in the signature.}
#' }
#'
#' @source Internal metadata
"Metadata_Sig"
