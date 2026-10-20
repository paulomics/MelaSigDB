MelaSigDB <img src="man/MelaSigDB.png" width="181px" align="right" />
===========

**MelaSigDB** is an R package for exploring and retrieving transcriptomics gene signatures relevant to melanoma research. It is intended to make signature information easier to reuse in downstream transcriptomic analyses, including bulk and single-cell workflows. Gene signatures can be used to interpret expression patterns and to calculate signature scores in downstream analyses. Depending on the biological question and the method used, retrieved genes or ranked signatures may be suitable for workflows involving tools such as **Seurat**, **DESeq2**, **GSVA**, or **fgsea**.


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
- `Plot_Sig_in_Panel()` — visualise distribution of a ranked gene signature in a give genes panel (e.g. Xenium panel).

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

The exact arguments depend on the query you want to make. Start by checking the function documentation, then use the search and retrieval functions to identify the signature(s) of interest.

```r

```

## Data and references

MelaSigDB includes a signature collection and associated reference information. For interpretation and reproducibility, consult the references provided with the relevant signature and cite the original publication when using that signature in research.

To inspect the references available in the installed package:

```r
Loaded_references()
```
## License

Please refer to the repository's `LICENSE` file for the applicable license.
