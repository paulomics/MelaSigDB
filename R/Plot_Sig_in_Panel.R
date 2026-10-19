#' Plot_Sig_in_Panel
#'
#' @param ranked_sig_gene_set Name of the signature.
#' @param panel_gene_set Top genes cutoff.
#' @return Plot of overlapping genes set.
#' @export
Plot_Sig_in_Panel <- function(ranked_sig_gene_set, panel_gene_set) {
  ranked_sig_gene_set <- unique(ranked_sig_gene_set)
  panel_gene_set <- unique(panel_gene_set)

  hits <- ranked_sig_gene_set %in% panel_gene_set

  Nh <- sum(hits)
  N  <- length(ranked_sig_gene_set)
  Nm <- N - Nh

  if (Nh == 0)
    stop("No overlap")

  running_ES <- cumsum(ifelse(hits, 1 / Nh, -1 / Nm))

  df_curve <- data.frame(Rank = seq_len(N), ES   = running_ES)

  df_hits <- data.frame(Rank = which(hits))

  p <- ggplot(df_curve, aes(Rank, ES)) +

    geom_rect(
      data = df_hits,
      inherit.aes = FALSE,
      aes(
        xmin = Rank - 0.5,
        xmax = Rank + 0.5,
        ymin = min(df_curve$ES),
        ymax = max(df_curve$ES)
      ),
      fill = "grey50",
      alpha = 0.5
    ) +

    geom_line(colour = "red", linewidth = 1) +

    geom_hline(yintercept = 0, linetype = 2) +

    labs(
      title = paste0(Nh, "/", N, " genes overlap with panel"),
      x = "Rank",
      y = "Enrichment score"
    ) +

    coord_cartesian(expand = c(0, 0)) +

    theme_classic(base_size = 14) +

    theme(
      plot.title = element_text(
        size = 18,
        face = "bold",
        hjust = 0.5
      ),
      axis.title.y = element_text(size = 15, face = "bold"),
      axis.title.x = element_text(size = 15, face = "bold"),
      axis.text.y = element_text(
        size = 12,
        face = "bold",
        colour = "black"
      ),
      axis.text.x = element_text(
        size = 12,
        face = "bold",
        colour = "black"
      ),
      axis.line = element_line(linewidth = 0.8),
      axis.ticks = element_line(linewidth = 0.7),
      legend.position = "none",
      panel.grid.major.y = element_line(
        color = "gray80",
        linewidth = 0.3,
        linetype = "dashed"
      )
    )

  print(p)

  invisible(list(
    overlap = intersect(ranked_sig_gene_set, panel_gene_set),
    hit_positions = which(hits)
  ))
}
