# Runs the three study scripts in order and rebuilds results/ from data/. From this folder: Rscript run_all.R
# Each script is run with Rscript from code/; its console output goes to results/logs/.
# Study2.R uses the Study 1 model saved by Study1.R (Figure 2 shows both studies), so Study1.R runs first.
rscript <- file.path(R.home("bin"), "Rscript")
dir.create("results/logs", recursive = TRUE, showWarnings = FALSE)
run <- function(f, echo = FALSE) {
  log <- normalizePath(file.path("results/logs", paste0(f, ".txt")), mustWork = FALSE)
  old <- setwd("code"); on.exit(setwd(old))
  cat("Running", f, "\n")
  args <- if (echo) c("-e", shQuote(sprintf("pdf(NULL); source('%s.R', echo = TRUE, max.deparse.length = Inf, encoding = 'UTF-8')", f))) else paste0(f, ".R")
  if (system2(rscript, c("--vanilla", args), stdout = log, stderr = log) != 0) stop(f, ".R failed; see ", log)
}
run("Study1", echo = TRUE)   # printed model output with the code that produced it
run("Study2", echo = TRUE)
run("Study3")
src <- unlist(lapply(list.files("code", "[.]R$", full.names = TRUE), readLines, encoding = "UTF-8"))
pkgs <- sort(unique(unlist(regmatches(src, gregexpr("(?<=library\\()[A-Za-z0-9.]+|[A-Za-z0-9.]+(?=::)", src, perl = TRUE)))))
invisible(lapply(setdiff(pkgs, c("base", "stats", "utils", "grDevices", "graphics", "tools")), loadNamespace))
writeLines(capture.output(sessionInfo()), "results/sessionInfo.txt")
cat("Done.\n")
