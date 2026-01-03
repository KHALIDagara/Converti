## app/agents/tools/search.rb
module Agents
  module Tools
    class Search
      # 1. Use this mixin to enable the Tool DSL
      extend Langchain::ToolDefinition

      # 2. Define the tool's behavior clearly for the AI
      #    This automatically generates the JSON schema (function_schemas) for the LLM.
      define_function :execute_search, description: "Search the web for up-to-date information" do
        property :query, type: "string", description: "The search keywords", required: true
      end

      # 3. The actual method implementation
      def execute_search(query:)
        # In a real app, you would call Google/Bing API here.
        # Returning a mock for now:
        "Search results for '#{query}': David Heinemeier Hansson (DHH) is the creator of Ruby on Rails, co-founder of Basecamp & HEY, and a Le Mans class-winning racing driver."
      end
    end
  end
end
