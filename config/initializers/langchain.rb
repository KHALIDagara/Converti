# config/initializers/langchain.rb

module LangchainConfig
  def self.llm
    @llm ||= Langchain::LLM::OpenAI.new(
      api_key: ENV['OPENROUTER_API_KEY'], # Your 'sk-or-...' key
      
      # 1. Set the default model you want to use
      default_options: {
        chat_completion_model_name: 'openai/gpt-4o-mini', # Example model
        temperature: 0.2
      },

      # 2. Override the Base URL to point to OpenRouter
      llm_options: {
        uri_base: "https://openrouter.ai/api/v1",
        
        # OpenRouter recommends these headers for rankings/stats
        extra_headers: {
          "X-Title" => "My Rails App"               # Optional: Your app name
        }
      }
    )
  end
end
