# SenateData: A Functional Tool for the SenateData Dataset

`SenateData` is a package designed to allow a user with only basic knowledge of R to interact with SenateData, a dataset with over 1,100 variables that compiles information about all US Senators and state-years across 1789-2025, and its codebook. The dataset tracks state characteristics, Senators, and the behavior of those Senators in policymaking. Users can find variables related to state- and member-level demographics, politics, and policy; subset the data across multiple dimensions; and access citations in both plain text and BibTeX for every variable.

## Installing this Package

The dataset and its codebook are included in the package. Install the package from GitHub like so:

``` r
# install devtools first if you do not have it: install.packages("devtools")
devtools::install_github("ippsr/SenateData")

library(SenateData)
```

## Using the Package

The package has three functions:

| Function | What it does |
|---|---|
| `get_senate_data()` | Loads the dataset, optionally subset by state, topic, and year |
| `get_var_info()` | Looks up variables in the codebook: what they measure, the years they cover, their source, and their citations |
| `get_cites()` | Returns the citations for the variables you use, in plain text or BibTeX |

The full dataset and codebook are also available directly as `senate` and `codebook`.

### Loading the data

Each row of SenateData is a senator-year. Called with no arguments,
`get_senate_data()` returns the whole dataset.

``` r
senate_all <- get_senate_data()
```

Use `states` and `years` to keep only the rows you need. States can be full
names or two-letter abbreviations, in any letter case. Years can be a single
year or a first and last year.

``` r
# Michigan's senators in 2008
get_senate_data(states = "Michigan", years = 2008)

# Michigan and Ohio, 2000 through 2010
mi_oh <- get_senate_data(states = c("MI", "OH"), years = c(2000, 2010))
```

Use `related_to` to keep only the variables on a topic. It searches each
variable's name, descriptions, source, and category in the codebook (not case
sensitive) and keeps the matches, along with the identifier columns (names,
state, `bioguide`, `icpsr`, `year`, `congress_number`, and so on).

``` r
# environment-related variables for every senator
env <- get_senate_data(related_to = "environment")

# several search terms at once, combined with state and year filters
ideology <- get_senate_data(states = "Michigan",
                            related_to = c("cfscore", "nominate"),
                            years = c(1990, 2020))
```

### Finding variables

`get_var_info()` searches the codebook. With no arguments it returns the whole
codebook.

``` r
# every variable whose name contains "dime_"
get_var_info(var_names = "dime_")

# one variable, matched exactly
get_var_info(var_names = "lcv_score", exact = TRUE)

# variables whose descriptions or sources mention poverty or population
get_var_info(related_to = c("poverty", "population"))
```

Each row gives the variable's `years`, `short_desc`, `long_desc`, `sources`,
`category`, and its citations (`plaintext_cite`, `bibtex_cite`, and up to four
more in `plaintext_cite2`-`5` and `bibtex_cite2`-`5`).

### Citing the variables you use

`get_cites()` takes variable names or a data frame and returns the citation
for every source behind those variables. Each source is listed once, even when
many variables share it, and the citation for SenateData itself comes first.

``` r
get_cites("lcv_score")
#> Yoel, Benjamin, and Iliya Liampert. 2026. SenateData Project. V.1.3. IPPSR.
#>
#> League of Conservation Voters. National Environmental Scorecard, 1971-2025.
#> Washington, DC: League of Conservation Voters. https://scorecard.lcv.org/
```

Pass it the data you loaded to cite everything in it:

``` r
ideology <- get_senate_data(related_to = "dime_")
get_cites(ideology)
```

Use `format = "bibtex"` for BibTeX entries, and `file` to save them as a `.bib`
file for LaTeX, R Markdown, or Quarto:

``` r
get_cites(ideology, format = "bibtex", file = "senatedata_refs.bib")
```

`get_cites()` warns you about any variable it cannot cite, for example a
variable with no BibTeX entry in the codebook. Use `format = "plaintext"` for
those.

## Dataset and Package Citation

In addition to citing each variable’s source, we ask that you cite
SenateData if you use this package or the dataset:

> Yoel, Benjamin, and Iliya Liampert. 2026. SenateData Project. V.1.3. IPPSR.

You can also get this citation, with a BibTeX entry, from R:

``` r
citation("SenateData")
```

# Contact

[**Benjamin Yoel**](https://benjaminyoel.com/) - Jan Koum Postdoctoral Fellow, Stanford University’s Center on Democracy.

[**Iliya Liampert**](https://iliyaliampert.com/) - PhD Candidate,
Michigan State University
