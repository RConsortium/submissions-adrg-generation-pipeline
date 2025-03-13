deepseek <- function(prompt, 
                    modelName = "deepseek-reasoner",
                    temperature = 0,
                    apiKey = Sys.getenv("deepseek_API_KEY")) {
  
  if(nchar(apiKey)<1) {
    apiKey <- readline("Paste your API key here: ")
    Sys.setenv(deepseek_API_KEY = apiKey)
  }
  
  response <- POST(
    url = "https://api.deepseek.com/chat/completions", 
    add_headers(Authorization = paste("Bearer", apiKey)),
    content_type_json(),
    encode = "json",
    body = list(
      model = modelName,
      temperature = temperature,
      messages = list(list(
        role = "user", 
        content = prompt
      ))
    )
  )
  
  if(status_code(response)>200) {
    stop(content(response))
  }
  
  trimws(content(response)$choices[[1]]$message$content)
}
