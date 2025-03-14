#' @title LLM Logging Utilities
#' @description Functions for logging LLM API calls to files
#' @keywords internal

# Create logs directory if it doesn't exist
ensure_logs_dir <- function() {
  logs_dir <- "logs"
  if (!dir.exists(logs_dir)) {
    dir.create(logs_dir, recursive = TRUE)
  }
  logs_dir
}

#' Mark the start of a new run in the log file
#'
#' @param run_description Optional description of the run
#' @export
mark_run_start <- function(run_description = "") {
  logs_dir <- ensure_logs_dir()
  date <- format(Sys.time(), "%Y%m%d")
  log_file <- file.path(logs_dir, sprintf("llm_calls_%s.log", date))
  timestamp <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")

  run_header <- sprintf(
    "\n\n%s\n=== NEW RUN STARTED ===\nTimestamp: %s\nDescription: %s\n%s\n",
    paste(rep("=", 80), collapse = ""),
    timestamp,
    ifelse(run_description == "", "No description provided", run_description),
    paste(rep("=", 80), collapse = "")
  )

  write(run_header, log_file, append = TRUE)
  cat(run_header)
}

#' Log LLM call details to a daily log file
#'
#' @param prompt The prompt sent to the LLM
#' @param model The model used for the call
#' @param response The response received from the LLM
#' @param temperature The temperature setting used (default: 0)
#' @export
log_llm_call <- function(prompt, model, response, temperature = 0) {
  logs_dir <- ensure_logs_dir()

  # Create date-based filename
  date <- format(Sys.time(), "%Y%m%d")
  log_file <- file.path(logs_dir, sprintf("llm_calls_%s.log", date))

  # Create timestamp for the entry
  timestamp <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")

  # Create log entry with more compact formatting
  log_entry <- sprintf(
    "\n=== LLM Call Log === [%s] Model: %s | Temp: %s\nPrompt:\n%s\n\nResponse:\n%s\n%s\n",
    timestamp,
    model,
    temperature,
    prompt,
    response,
    paste(rep("=", 80), collapse = "") # Separator line between entries
  )

  # Append to file
  write(log_entry, log_file, append = TRUE)

  # Also print to console for visibility
  cat(log_entry)
}
