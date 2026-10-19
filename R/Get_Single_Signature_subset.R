#' Get_Single_Signature_Rank
#'
#' @param signature Name of the signature.
#' @param top_genes_cutoff Top genes cutoff.
#' @param logFC_cutoff FC cutoff.
#' @param organism_format Name of organism for the output gene format
#' @param gene_format Name of the gene format
#' @param output_format Name of the output format
#' @return Vector of genes associated with the signatures.
#' @export
Get_Single_Signature_Rank <- function(signature = NULL,
                                      top_genes_cutoff = NULL,
                                      logFC_cutoff = NULL,
                                      organism_format = "human",
                                      gene_format = "symbol",
                                      output_format = "data.frame") {
  df <- MelaSigDB::Metadata_Sig

  if (is.null(signature)) {
    stop("Please provide a signature.")
  }

  if (!signature %in% df$signature_id) {
    stop(
      "'signature' must be a excat signature id. Signature ID can be finded with MelaSigDB::Search_Signature function."
    )
  }

  ranking_method <- df[df$signature_id == signature, ]$ranking
  ranking_reference <- df[df$signature_id == signature, ]$reference
  ranking_organism <- df[df$signature_id == signature, ]$organism

  if (ranking_method == "rank") {
    if (!is.null(logFC_cutoff)) {
      stop(
        "'logFC_cutoff' and 'pval_cutoff' are not applicable for a signature with a gene r'ordering' ranking. Please provide only 'top_genes_cutoff'."
      )
    }
    if (is.null(top_genes_cutoff) | !is.numeric(top_genes_cutoff)) {
      stop(
        "Please provide a valid numeric value for 'top_genes_cutoff' to apply the 'ordering' ranking method."
      )
    }
    rank_all <- system.file(
      "extdata/ranking/ordering.csv",
      package = "MelaSigDB"
    )
    rank_all <- rank_all[rank_all$SIGNATURE == signature, ]
    if (top_genes_cutoff > length(na.omit(unique(rank_all$HUMAN_SY)))) {
      top_genes_cutoff <- length(na.omit(unique(rank_all$HUMAN_SY)))
      message(
        paste0(
          "'top_genes_cutoff' greater than the number of genes in the signatures. 'top_genes_cutoff' set on ",
          top_genes_cutoff
        )
      )
    } else {
      rank_all <- rank_all[1:top_genes_cutoff, ]
    }
    message(
      paste0(
        "Selection of the ",
        top_genes_cutoff,
        " top genes with by logFC in '",
        signature,
        "' signature."
      )
    )
    rank_genes <- na.omit(unique(rank_all$HUMAN_SY))
  }

  if (ranking_method == "expr") {
    if (!is.null(logFC_cutoff)) {
      stop(
        "'logFC_cutoff' and 'pval_cutoff' are not applicable for a signature with a gene 'expr' ranking. Please provide only 'top_genes_cutoff'."
      )

    }
    if (is.null(top_genes_cutoff) | !is.numeric(top_genes_cutoff)) {
      stop(
        "Please provide a valid numeric value for 'top_genes_cutoff' to apply the 'expr' ranking method."
      )
    }
    if (!is.null(top_genes_cutoff) | is.numeric(top_genes_cutoff)) {
      rank_df <- system.file(
        paste0("extdata/ranking/", ranking_reference, ".csv"),
        package = "MelaSigDB"
      )
      rank_df <- rank_df[rank_df$cluster == signature, ]
      rank_df <- aggregate(cbind(prol_med_expr, inv_med_expr) ~ gene,
                           data = rank_df,
                           FUN = mean)
      if (grepl("prol", signature)) {
        rank_df_or <- rank_df[order(rank_df$prol_med_expr, decreasing = TRUE), ]
      }
      if (grepl("inv", signature)) {
        rank_df_or <- rank_df[order(rank_df$inv_med_expr, decreasing = TRUE), ]
      }
      rank_genes <- rank_df_or$gene[1:top_genes_cutoff]

      message(paste0(
        "Selection of ",
        length(rank_genes),
        " genes in '",
        signature,
        "' signature."
      ))

    }
  }

  if (ranking_method == "de") {
    if (is.null(logFC_cutoff) & is.null(top_genes_cutoff)) {
      stop(
        "Please provide 'logFC_cutoff' or 'top_genes_cutoff' to subset a signature with a gene 'de' ranking."
      )
    }
    if (!is.null(logFC_cutoff) & !is.null(top_genes_cutoff)) {
      stop("Please choose between 'logFC_cutoff' and 'top_genes_cutoff' subset method.")
    }
    rank_df <- system.file(
      paste0("extdata/ranking/", ranking_reference, ".csv"),
      package = "MelaSigDB"
    )
    rank_df <- rank_df[rank_df$cluster == signature, ]

    if (!is.null(top_genes_cutoff) &
        is.numeric(top_genes_cutoff) & is.null(logFC_cutoff)) {
      if (top_genes_cutoff > length(rank_df$gene)) {
        message(
          "'top_genes_cutoff' greater than the number of genes in the signatures. All genes selected."
        )
        top_genes_cutoff <- length(rank_df$gene)
      }
      message(
        paste0(
          "Selection of the ",
          top_genes_cutoff,
          " top genes with by logFC in '",
          signature,
          "' signature."
        )
      )
      rank_genes <- rank_df$gene[order(rank_df$avg_logFC, decreasing = TRUE)][1:top_genes_cutoff]
      message(paste0(
        "Selection of ",
        length(rank_genes),
        " genes in '",
        signature,
        "' signature."
      ))
    }
    if (!is.null(logFC_cutoff) &
        is.numeric(logFC_cutoff) & is.null(top_genes_cutoff)) {
      message(
        paste0(
          "Selection of the genes with logFC > ",
          logFC_cutoff,
          " in '",
          signature,
          "' signature."
        )
      )
      rank_genes <- rank_df$gene[rank_df$avg_logFC > logFC_cutoff]
      message(paste0(
        "Selection of ",
        length(rank_genes),
        " genes in '",
        signature,
        "' signature."
      ))
    }
  }

  if (!is.null(rank_genes)) {
    if (tolower(ranking_organism) == tolower(organism_format) &
        tolower(gene_format) %in% c("symbol", "sy")) {
      if (tolower(output_format) %in% c("data.frame", "dataframe", "df")) {
        MelSign_sets <- data.frame(SIGNATURE = signature, gene = rank_genes)
        return(MelSign_sets)
      }

      if (tolower(output_format) %in% c("list")) {
        MelSign_sets <- split(rank_genes, signature)
        return(MelSign_sets)
      }

      if (tolower(output_format) %in% c("named_vector", "namevector")) {
        MelSign_sets <- setNames(rank_genes, signature)
        return(MelSign_sets)
      }
      if (tolower(output_format) %in% c("vector")) {
        MelSign_sets <- unique(na.omit(rank_genes))
        return(MelSign_sets)
      }


    } else {
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

      MelSign_sets <- MelSign_sets[MelSign_sets$SIGNATURE %in% signature, ]

      if (tolower(ranking_organism) == "human") {
        format_target <- "HUMAN_SY"
      }
      if (tolower(ranking_organism) == "mouse") {
        format_target <- "MOUSE_SY"
      }
      MelSign_sets <- MelSign_sets[MelSign_sets[[format_target]] %in% rank_genes, ]
      MelSign_sets <- subset(MelSign_sets, select = c("SIGNATURE", id_format))
      MelSign_sets <- MelSign_sets[!duplicated(MelSign_sets), ]
      MelSign_sets <- na.omit(MelSign_sets)


      if (!tolower(output_format) %in% c(
        "data.frame",
        "dataframe",
        "df",
        "list",
        "named_vector",
        "vector",
        "namevector"
      )) {
        MelSign_sets <- setNames(MelSign_sets$MOUSE_SY, MelSign_sets$SIGNATURE)
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
        MelSign_sets <- unique(na.omit(MelSign_sets[[id_format]]))
        return(MelSign_sets)
      }

    }

  } else {
    stop("No genes for this signatures and parameters.")
  }
}
