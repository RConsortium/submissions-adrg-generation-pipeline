library(testthat)
library(ellmer)
library(mockery)
library(here)

# Source the LLM API file
source(here("pipeline", "utils", "llm_api.R"))

# Define test that mocks ellmer's chat functions to avoid actual API calls
test_that("llm_call creates correct chat object and gets response", {
  # Create a mock chat object with a chat method
  mock_chat <- structure(list(chat = function(prompt) {
    "This is a mock response"
  }), class = "Chat")
  
  # Mock the ellmer::chat_openai function to return our mock chat object
  mock_fn <- mock(mock_chat)
  with_mocked_bindings(
    chat_openai = mock_fn,
    .package = "ellmer",
    {
      # Call our function
      result <- llm_call(
        prompt = "Test prompt",
        provider = "openai",
        model = "gpt-4o"
      )
      
      # Check the result
      expect_equal(result, "This is a mock response")
      
      # Verify chat_openai was called with the right arguments
      expect_called(mock_fn, 1)
      args <- mock_args(mock_fn)[[1]]
      expect_equal(args$model, "gpt-4o")
      expect_equal(args$echo, "none")
    }
  )
})


test_that("llm_call uses system prompt correctly", {
  # Create a mock chat object
  mock_chat <- structure(list(chat = function(prompt) {
    "Response with system prompt"
  }), class = "Chat")
  
  # Mock the ellmer::chat_openai function
  mock_fn <- mock(mock_chat)
  with_mocked_bindings(
    chat_openai = mock_fn,
    .package = "ellmer",
    {
      # Call our function with a system prompt
      result <- llm_call(
        prompt = "Test prompt",
        model = "gpt-3.5-turbo",
        provider = "openai",
        system_prompt = "You are a helpful assistant"
      )
      
      # Verify chat_openai was called with the right arguments
      expect_called(mock_fn, 1)
      args <- mock_args(mock_fn)[[1]]
      expect_equal(args$system_prompt, "You are a helpful assistant")
    }
  )
})

test_that("llm_call passes additional parameters correctly", {
  # Create a mock chat object
  mock_chat <- structure(list(chat = function(prompt) {
    "Response with additional parameters"
  }), class = "Chat")
  
  # Mock the ellmer::chat_openai function
  mock_fn <- mock(mock_chat)
  with_mocked_bindings(
    chat_openai = mock_fn,
    .package = "ellmer",
    {
      # Call our function with additional parameters
      result <- llm_call(
        prompt = "Test prompt",
        model = "gpt-3.5-turbo",
        provider = "openai",
        temperature = 0.7,
        max_tokens = 1000
      )
      
      # Verify chat_openai was called with the right arguments
      expect_called(mock_fn, 1)
      args <- mock_args(mock_fn)[[1]]
      expect_equal(args$temperature, 0.7)
      expect_equal(args$max_tokens, 1000)
    }
  )
})

test_that("llm_extract_structured creates correct chat object and extracts data", {
  # Create a mock chat object with an extract_data method
  mock_chat <- structure(list(extract_data = function(prompt, type) {
    list(result = "structured data")
  }), class = "Chat")
  
  # Create a mock type object
  mock_type <- structure(list(), class = "Type")
  
  # Mock the ellmer::chat_claude function
  mock_fn <- mock(mock_chat)
  with_mocked_bindings(
    chat_claude = mock_fn,
    .package = "ellmer",
    {
      # Call our function
      result <- llm_extract_structured(
        prompt = "Extract data",
        provider = "anthropic",
        type = mock_type
      )
      
      # Check the result
      expect_equal(result, list(result = "structured data"))
      
      # Verify chat_claude was called with the right arguments
      expect_called(mock_fn, 1)
    }
  )
})

# Test with actual API call but skip if no API keys are available
test_that("llm_call works with real API (if available)", {
  skip_if_not(nchar(Sys.getenv("OPENAI_API_KEY")) > 0, "No OpenAI API key available")
  
  # Only run this test if an API key is available
  result <- llm_call(
    prompt = "Say hello in one word",
    provider = "openai",
    model = "gpt-3.5-turbo" # Use a cheaper model for testing
  )
  
  # Check that we got some response
  expect_type(result, "character")
  expect_true(nchar(result) > 0)
})