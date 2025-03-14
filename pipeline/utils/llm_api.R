# Define supported models and their configurations
SUPPORTED_MODELS <- list(
  # OpenAI models
  "gpt-4o" = list(
    provider = "openai",
    env_var = "OPENAI_API_KEY"
  ),
  "o3-mini" = list(
    provider = "openai",
    env_var = "OPENAI_API_KEY"
  ),
  # DeepSeek models
  "deepseek-reasoner" = list(
    provider = "deepseek",
    env_var = "DEEPSEEK_API_KEY"
  ),
  "deepseek-chat" = list(
    provider = "deepseek",
    env_var = "DEEPSEEK_API_KEY"
  ),
  # Anthropic Claude models
  "claude-3-7-sonnet-latest" = list(
    provider = "anthropic",
    env_var = "ANTHROPIC_API_KEY"
  ),
  "claude-3-5-sonnet-latest" = list(
    provider = "anthropic",
    env_var = "ANTHROPIC_API_KEY"
  ),
  "claude-3-5-haiku-latest" = list(
    provider = "anthropic",
    env_var = "ANTHROPIC_API_KEY"
  )
)


# OpenAI API request function
openai_request <- function(prompt, model, temperature, api_key) {
  response <- httr::POST(
    url = "https://api.openai.com/v1/chat/completions",
    httr::add_headers(
      "Authorization" = paste("Bearer", api_key),
      "Content-Type" = "application/json"
    ),
    body = list(
      model = model,
      messages = list(list(
        role = "user",
        content = prompt
      )),
      temperature = temperature
    ),
    encode = "json"
  )

  if (httr::status_code(response) > 200) {
    stop(paste("OpenAI API call failed:", httr::content(response)))
  }

  trimws(httr::content(response)$choices[[1]]$message$content)
}

# Deepseek API request function
deepseek_request <- function(prompt, model, temperature, api_key) {
  response <- httr::POST(
    url = "https://api.deepseek.com/v1/chat/completions",
    httr::add_headers(
      "Authorization" = paste("Bearer", api_key),
      "Content-Type" = "application/json"
    ),
    body = list(
      model = model,
      messages = list(list(
        role = "user",
        content = prompt
      )),
      temperature = temperature
    ),
    encode = "json"
  )

  if (httr::status_code(response) > 200) {
    stop(paste("Deepseek API call failed:", httr::content(response)))
  }

  trimws(httr::content(response)$choices[[1]]$message$content)
}

# Anthropic API request function
anthropic_request <- function(prompt, model, temperature, api_key) {
  response <- httr::POST(
    url = "https://api.anthropic.com/v1/messages",
    httr::add_headers(
      "x-api-key" = api_key,
      "anthropic-version" = "2023-06-01",
      "Content-Type" = "application/json"
    ),
    body = list(
      model = model,
      max_tokens = 4096,
      temperature = temperature,
      messages = list(list(
        role = "user",
        content = prompt
      ))
    ),
    encode = "json"
  )

  if (httr::status_code(response) > 200) {
    stop(paste("Anthropic API call failed:", httr::content(response)))
  }

  trimws(httr::content(response)$content[[1]]$text)
}

# Unified LLM function that routes to appropriate API based on model
llm_call <- function(prompt, model, temperature = 0) {
  # Validate model
  if (!model %in% names(SUPPORTED_MODELS)) {
    stop(sprintf(
      "Model '%s' not supported. Supported models are: %s",
      model, paste(names(SUPPORTED_MODELS), collapse = ", ")
    ))
  }

  # Get model configuration
  model_config <- SUPPORTED_MODELS[[model]]

  # Get API key from environment
  api_key <- Sys.getenv(model_config$env_var)
  if (nchar(api_key) < 1) {
    stop(sprintf(
      "API key not found in environment variables. Please set %s in your .Renviron file",
      model_config$env_var
    ))
  }

  # Route to appropriate API based on provider
  switch(model_config$provider,
    "openai" = openai_request(prompt, model, temperature, api_key),
    "deepseek" = deepseek_request(prompt, model, temperature, api_key),
    "anthropic" = anthropic_request(prompt, model, temperature, api_key),
    stop(sprintf("Unsupported provider: %s", model_config$provider))
  )
}
