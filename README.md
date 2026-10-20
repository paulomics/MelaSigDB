MelaSigDB <img src="man/icon/MelaSigDB.png" width="181px" align="right" />
===========

**MelaSigDB** is an R package for exploring and retrieving transcriptomics gene signatures relevant to melanoma research. It is intended to make signature information easier to reuse in downstream transcriptomic analyses, including bulk, single-cell and spacial workflows. Gene signatures can be used to interpret expression patterns and to calculate signature scores in downstream analyses. 

Repository: <https://github.com/paulomics/MelaSigDB>

> **Development status:** MelaSigDB is under active development. Function interfaces and the signature collection may change between versions.

## Installation

Install the development version from GitHub:

```r
# install.packages("remotes")
remotes::install_github("paulomics/MelaSigDB")
```

Load the package:

```r
library(MelaSigDB)
```

## Main features

The package exports functions for working with the signature collection:

- `Search_Signature()` — search the available signatures in MelaSigDB.
- `Get_Signature()` — retrieve gene signatures for a choosen gene and object format.
- `Get_Single_Signature_Rank()` — retrieve gene fo a specific signature ranked according how they were distributed in the literature..
- `Infos_Signature()` — inspect information associated with a signature.
- `Loaded_references()` — inspect the references of the sigantures avaialble in MelaSigDB.
- `Plot_Sig_in_Panel()` — visualize distribution of a ranked gene signature in a give genes panel (e.g. Xenium panel).
- `MelaSigDB()` — to get MelaSigDB data as a dataframe.
- `Meatada_sig()` — to get MelaSigDB metadata as a dataframe.

See the function help pages for the current arguments and return values:

```r
?Search_Signature
?Get_Signature
?Get_Single_Signature_Rank
?Infos_Signature
?Loaded_references
?Plot_Sig_in_Panel
```

## Example workflow

The exact arguments depend on the query you want to make. Start by checking the function documentation, then use the search and retrieval functions to identify the signature(s) of interest.\

Here we retrieve a dataframe with the genes in ZEB1 and TRIM24 regulons in mouse-symbol format:

```r
library(MelaSigDB)

combined_sig <- MelaSigDB::Get_Signature(signature = c("trim24", "zeb1"),
                          organsim = "all",
                          method = "all",
                          organism_format = "mouse",
                          gene_format = "symbol",
                          output_format = "data.frame")
```

Here we retrieve all the signatures made from scRNA-seq data in human-ensembl format:

```r
library(MelaSigDB)

combined_sig <- MelaSigDB::Get_Signature(signature = "all",
                          organsim = "all",
                          method = "scrna",
                          organism_format = "mouse",
                          gene_format = "ensembl",
                          output_format = "data.frame")

```
Here we retrieve the top 10 genes in ZEB1 and TRIM24 regulons in human-entrez format:

```r
library(MelaSigDB)

signatures_to_get <- MelaSigDB::Search_Signature(signature = "trim24")
signatures_to_get <- c(signatures_to_get, MelaSigDB::Search_Signature(signature = "zeb1"))

combined_sig <- data.frame(SIGNATURE = character(),
                           gene = character())
for (i in signatures_to_get){
  ranked <- MelaSigDB::Get_Single_Signature_Rank(signature = i, top_genes_cutoff =10, organism_format = "human", gene_format = "entrez", output_format = "data.frame")
  combined_sig <- rbind(combined_sig, ranked)
}

```

## Data and references

MelaSigDB includes a signature collection and associated reference information. For interpretation and reproducibility, consult the references provided with the relevant signature and cite the original publication when using that signature in research.

To inspect the references available in the installed package:

```r
Loaded_references()
```
## License

Please refer to the repository's `LICENSE` file for the applicable license.
