library(testthat)
library(httr)

# Load environment variables from project root .Renviron
readRenviron("../../.Renviron")

# Set environment variables for testing
# Replace these with your actual API keys from .Renviron
Sys.setenv(
  OPENAI_API_KEY = Sys.getenv("OPENAI_API_KEY", ""),
  DEEPSEEK_API_KEY = Sys.getenv("DEEPSEEK_API_KEY", ""),
  ANTHROPIC_API_KEY = Sys.getenv("ANTHROPIC_API_KEY", "")
)

# Source the LLM API file
source("../../pipeline/utils/llm_api.R")

# Skip tests if API keys are not available
skip_if_no_api_keys <- function() {
  has_openai <- nchar(Sys.getenv("OPENAI_API_KEY")) > 0
  has_deepseek <- nchar(Sys.getenv("DEEPSEEK_API_KEY")) > 0
  has_anthropic <- nchar(Sys.getenv("ANTHROPIC_API_KEY")) > 0

  if (!has_openai && !has_deepseek && !has_anthropic) {
    skip("No API keys found in environment variables")
  }
}

test_that("OpenAI API calls work", {
  skip_if_no_api_keys()

  # Test with GPT-4
  if (nchar(Sys.getenv("OPENAI_API_KEY")) > 0) {
    result <- llm_call(
      prompt = "Say hello!",
      model = "gpt-4o",
      temperature = 0
    )
    expect_type(result, "character")
    expect_true(nchar(result) > 0)
  }
})

test_that("Deepseek API calls work", {
  skip_if_no_api_keys()

  # Test with Deepseek Chat
  if (nchar(Sys.getenv("DEEPSEEK_API_KEY")) > 0) {
    result <- llm_call(
      prompt = "Say hello!",
      model = "deepseek-chat",
      temperature = 0
    )
    expect_type(result, "character")
    expect_true(nchar(result) > 0)
  }
})

test_that("Anthropic API calls work", {
  skip_if_no_api_keys()

  # Test with Claude
  if (nchar(Sys.getenv("ANTHROPIC_API_KEY")) > 0) {
    result <- llm_call(
      prompt = "Say hello!",
      model = "claude-3-5-haiku-latest",
      temperature = 0
    )
    expect_type(result, "character")
    expect_true(nchar(result) > 0)
  }
})

test_that("Error handling works for invalid models", {
  expect_error(
    llm_call(
      prompt = "Say hello!",
      model = "invalid-model",
      temperature = 0
    ),
    "Model 'invalid-model' not supported"
  )
})

test_that("Error handling works for missing API keys", {
  # Temporarily unset API keys
  old_keys <- list(
    openai = Sys.getenv("OPENAI_API_KEY"),
    deepseek = Sys.getenv("DEEPSEEK_API_KEY"),
    anthropic = Sys.getenv("ANTHROPIC_API_KEY")
  )

  Sys.unsetenv("OPENAI_API_KEY")
  Sys.unsetenv("DEEPSEEK_API_KEY")
  Sys.unsetenv("ANTHROPIC_API_KEY")

  # Test error for missing OpenAI key
  expect_error(
    llm_call(
      prompt = "Say hello!",
      model = "gpt-4o",
      temperature = 0
    ),
    "API key not found in environment variables"
  )

  # Restore API keys
  Sys.setenv("OPENAI_API_KEY" = old_keys$openai)
  Sys.setenv("DEEPSEEK_API_KEY" = old_keys$deepseek)
  Sys.setenv("ANTHROPIC_API_KEY" = old_keys$anthropic)
})
