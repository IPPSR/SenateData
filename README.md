# SenateData: A Functional Tool for the SenateData Dataset

`SenateData` is a package designed to allow a user with only basic knowledge of R interact with SenateData, a dataset with over 960 variables that compiles information about all US Senators and state-years across 1789-2025, and its codebook. The dataset tracks state characteristics, Senators, and the behavior of those Senators in policymaking. Users can find variables related to state- and member-level demographics, politics, and policy; subset the data across multiple dimensions; create custom aggregations of the dataset; and access citations in both plain text and BibTeX for every variable.

## Installing this Package

`SenateData` is a functional package that interacts with the
SenateData dataset via the internet. Install the package from GitHub
like so:

``` r

# use the devtools library to download the package from GitHub
library(devtools)

# if there are issues or you only want to download SenateData
install_github("ippsr/SenateData")
```

## Finding Variables

`get_var_info`: Retrieve information regarding variables in SenateData
and identify variables of interest with `get_var_info`. The function
allows you to search to codebook to find the years each variable is
observed in the data; a short and long description of each variable; and
the source and citation/s for each variable. Citations are available in
both bibtex and plain text. Use the function to search for broad terms
like ‘tax’ with the `related_to` argument and/or partial-match variable
names with `var_names`.

``` r

suppressMessages(library(dplyr))
library(SenateData)
#> Please cite:
#> Yoel, Benjamin, and Iliya Liampert. 2025. SenateData Project. V.1.0. IPPSR. 
#> 
#> Run `SenateData::get_senate_version()` to print the version of SenateData
#> the package is using.
```



`get_var_info` returns the following information to simplify using
SenateData:

- variable: Variable name
- year: The precise years the variable is observed
- short_desc: A short description of the variable
- long_desc: A long description of the variable
- source: The sources of the data
- category: the variable’s category (not all are coded)
- plaintext_cite\[1-4\]: Plain text citation(s) for the data
- bibtext_cite\[1-4\]: BibTeX citation(s) for the data


## Accessing SenateData

`get_senate_data`: Access all or a part of SenateData with
`get_senate_data`. Subset by state names with `state` and years with
`years` (either a single year or a two-year vector that represents the
min/max of what you want). You can also use the `related_to` argument to
search across variable names, short/long descriptions from the codebook,
and citations for non-exact matches of a supplied term. For example,
searching ‘tax’ will return variables with words like ‘taxes’ and
‘taxable’ in any of those columns.

``` r

# load the entire dataset
all_the_dat <- get_senate_data()

# subset by state, topic, and years
sen_subset <- get_senate_data(states = c("Indiana","Kentucky","Michigan")
                             ,related_to = "tax"
                             ,years = c(1960,1980))
```

## Pulling Citations

`get_var_info`: Each variable in SenateData was collected from
external sources, please use `get_var_info` to obtain their citations
(plain text and BibTeX). We’ve made it easy to cite the source of each
variable you use with the `get_var_info` function described above.
Supply a vector of variable names to the function with the `var_names`
function and collect the citations provided in the plain text or BibTeX
columns. NOTE: Some variables have multiple citations, so do check you
have them all.

``` r

# bibtex is also available
get_var_info(var_names = "num_bills") %>%
  pull(plaintext_cite)
#> [1] "E. Scott Adler and John Wilkerson, Congressional Bills Project: 1973-2016, NSF 00880066 and 00880061.\n"
```

``` r

# bibtex is also available
get_var_info(var_names = "popfemale") %>%
  pull(plaintext_cite)
#> [1] "CQ Press. ’State Stats: Population under 5 years old.’ http://library.cqpress.com/cqresearcher/index.php."
```

## Dataset and Package Citation

In addition to citing each variable’s source, we ask that you cite
SenateData if use this package or the dataset:

> Yoel, Benjamin, and Iliya Liampert. 2025. SenateData Project. V.1.0. IPPSR.

# Contact

[**Benjamin Yoel**](https://benjaminyoel.com/) - PhD Candidate, Michigan
State University, and Predoctoral Fellow, Johns Hopkins University

[**Iliya Liampert**](https://liampert.github.io/) - PhD Student,
Michigan State University
