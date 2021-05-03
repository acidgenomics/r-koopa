# r-koopa

Internal R package dependency for [koopa](https://koopa.acidgenomics.com/).

```r
if (!requireNamespace("BiocManager", quietly = TRUE)) {
    install.packages("BiocManager")
}
install.packages(
    pkgs = "koopa",
    repos = c(
        "https://r.acidgenomics.com",
        BiocManager::repositories()
    )
)
```
