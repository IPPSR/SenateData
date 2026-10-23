# SenateData: A Functional Tool for the SenateData Dataset

`SenateData` is a package designed to allow a user with only basic knowledge of R interact with SenateData, a dataset with over 1000 variables that compiles information about all US Senators and state-years across 1789-2025, and its codebook. The dataset tracks state characteristics, Senators, and the behavior of those Senators in policymaking. Users can find variables related to state- and member-level demographics, politics, and policy; subset the data across multiple dimensions; create custom aggregations of the dataset; and access citations in both plain text and BibTeX for every variable.

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

## Dataset and Package Citation

In addition to citing each variable’s source, we ask that you cite
SenateData if you use this package or the dataset:

> Yoel, Benjamin, Iliya Liampert, and Matt Grossmann. Forthcoming. ``Determinants of Legislative Effectiveness: Exploring Senators, Their States, and Their Behavior with SenateData." Research \& Politics.

# Contact

[**Benjamin Yoel**](https://benjaminyoel.com/) - Jan Koum Postdoctoral Fellow, 
Stanford University’s Center on Democracy.

[**Iliya Liampert**](https://iliyaliampert.com/) - PhD Candidate,
Michigan State University
