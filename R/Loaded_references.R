#' Loaded_references
#' @return List of references
#' @export
Loaded_references <- function() {

  ref_dir <- system.file(
    "extdata/reference",
    package = "MelaSigDB"
  )
  files <- list.files(
    ref_dir,
    pattern = "\\.bib$",
    full.names = TRUE
  )
  refs <- lapply(files, RefManageR::ReadBib)
  names(refs) <- tools::file_path_sans_ext(basename(files))
  return(refs)
}
