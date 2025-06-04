# LLM API Documentation

This document provides a guide to using our provider-based LLM API, which leverages the ellmer package to interact with various large language model providers.

## Table of Contents

- [Installation](#installation)
- [Basic Usage](#basic-usage)
- [Provider-based Usage](#provider-based-usage)
- [Structured Data Extraction](#structured-data-extraction)
- [Error Handling](#error-handling)
- [Automatic Retries](#automatic-retries)

## Installation

Ensure you have the necessary packages installed:

```r
install.packages(c("ellmer", "jsonlite", "here"))
```

Set up appropriate API keys in your `.Renviron` file:

```
OPENAI_API_KEY=your_openai_key_here
ANTHROPIC_API_KEY=your_anthropic_key_here
# Add other provider keys as needed
```

## Basic Usage

The simplest way to call an LLM is:

```r
library(ellmer)
source("path/to/llm_api.R")

# Simple call with automatic provider inference
response <- llm_call(
  prompt = "Explain the concept of machine learning in simple terms",
  model = "claude-3-5-haiku-latest"
)
```

## Provider-based Usage

For more control, specify the provider explicitly:

```r
# Specify provider and model
response <- llm_call(
  prompt = "What are the best practices for data visualization?",
  provider = "anthropic",
  model = "claude-3-5-sonnet-latest"
)

# Using other providers
response <- llm_call(
  prompt = "Summarize the key concepts of reinforcement learning",
  provider = "gemini",
  model = "gemini-pro"
)
```

Note: The `model` parameter is required. If you don't specify a provider, the system will try to infer it from the model name.

## Structured Data Extraction

Extract structured data from text using ellmer's type system:

```r
# Define a schema
sentiment_type <- type_object(
  "Sentiment analysis of text",
  sentiment = type_enum(
    "The overall sentiment",
    values = c("positive", "neutral", "negative")
  ),
  confidence = type_number(
    "Confidence score (0-1)"
  ),
  key_points = type_array(
    "List of key points mentioned",
    items = type_string()
  )
)

# Extract structured data
result <- llm_extract_structured(
  prompt = "I've been using this product for a month now. It works well for most tasks, 
            but sometimes crashes when handling large files. Overall satisfied though!",
  provider = "anthropic",
  model = "claude-3-5-sonnet-latest",
  type = sentiment_type
)

# Access structured results
print(result$sentiment)        # "positive"
print(result$confidence)       # 0.85
print(result$key_points)       # List of extracted points
```

## Error Handling

The API provides helpful error messages when things go wrong:

- Provider not supported
- Model name not recognized
- API key missing or invalid
- Connection issues

Example:

```r
# Will give a helpful error if provider can't be inferred
response <- llm_call(
  prompt = "Hello world",
  model = "unknown-model-xyz"
)
# Error: Could not infer provider from model name: unknown-model-xyz
# Please specify the provider explicitly, e.g., provider='openai', provider='anthropic', etc.
# See https://ellmer.tidyverse.org/reference/index.html for supported providers and models.
```

## Automatic Retries

The API implements automatic retries with exponential backoff for transient errors:

```r
# All API calls automatically use retry logic
response <- llm_call(
  prompt = "Generate a story about a space explorer",
  provider = "anthropic",
  model = "claude-3-5-haiku-latest"
)
```

The retry mechanism:
- Makes up to 5 attempts by default
- Starts with a 2-second delay
- Doubles the delay after each failed attempt
- Handles rate limiting, server errors, and network issues
- Logs retry attempts with informative messages

You can see this implementation in action with the `retry_with_exponential_backoff` function that wraps all API calls.

## Supported Providers

The API supports all providers available in ellmer:

- OpenAI (`provider = "openai"`)
- Anthropic Claude (`provider = "anthropic"`)
- Google Gemini (`provider = "gemini"`)
- DeepSeek (`provider = "deepseek"`)
- Groq (`provider = "groq"`)
- Ollama (local models, `provider = "ollama"`)
- And many more

The following model naming patterns are automatically mapped to providers when provider isn't specified:

- Names starting with `gpt-`, `o1`, etc. → OpenAI
- Names starting with `claude` → Anthropic
- Names starting with `deepseek` → DeepSeek
- Names starting with `gemini` → Google Gemini
- Names starting with `mistral` or `mixtral` → Groq
- Names starting with `llama` → Ollama

For the complete list of supported providers, refer to the [ellmer documentation](https://ellmer.tidyverse.org/reference/index.html).