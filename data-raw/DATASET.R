src <- file.path("..", "Senate_Project", "most_recent_senateData")

load(file.path(src, "senate.rda"))    
load(file.path(src, "codebook.rda"))  

# --- Checks before overwriting data ---
stopifnot(
  is.data.frame(senate), is.data.frame(codebook),
  all(c("bioguide", "st", "year") %in% names(senate)),
  !anyDuplicated(senate[c("bioguide", "st", "year")]),          # one row per senator-state-year
  all(c("variable", "plaintext_cite", "bibtex_cite") %in% names(codebook))
)

# Data columns with no codebook entry
id_vars <- c("firstname", "lastname", "st", "bioguide", "icpsr", "govtrack",
             "start", "end", "year", "congress_number",
             "wikipedia", "wikidata", "google_entity_id", "house_history")
undocumented <- setdiff(names(senate), c(codebook$variable, id_vars))
if (length(undocumented)) {
  message("Variables without a codebook entry: ", paste(undocumented, collapse = ", "))
}

usethis::use_data(senate, codebook, overwrite = TRUE)
