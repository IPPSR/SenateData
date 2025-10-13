# prints when the package is attached using library()
.onAttach <- function(libname, pkgname) {
  packageStartupMessage("Please cite:\n")
  packageStartupMessage('Yoel, Benjamin, and Iliya Liampert. 2025. SenateData Project. V.1.0. IPPSR.’)
  packageStartupMessage("\nRun `SenateData::get_senate_version()` to print the version of SenateData the package is using.\n")
}