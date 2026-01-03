module Agents
  class BaseAgent
    def self.ask(content, tools: [], schema: nil)
      llm = LangchainConfig.llm

      # 1. Enhance Prompt with Schema Instructions
      full_prompt = content
      if schema
        full_prompt += "\n\nIMPORTANT: You must find the answer and then respond STRICTLY with valid JSON adhering to this schema:\n#{schema.to_json}"
      end

      # 2. Execute
      raw_response = if tools.any?
        assistant = ::Langchain::Assistant.new(llm: llm, tools: tools)
        
        # FIX: Add auto_tool_execution: true
        # This forces the agent to run the tool, get the mock result, 
        # and do a second pass to generate the final JSON.
        assistant.add_message_and_run(
          content: full_prompt, 
          auto_tool_execution: true
        )
        
        # The last message is now the Final Answer, not the Tool Call
        assistant.messages.last.content
      else
        options = { messages: [{ role: "user", content: full_prompt }] }
        options[:response_format] = { type: "json_object" } if schema
        llm.chat(**options).chat_completion
      end

      # 3. Parse JSON
      if schema
        begin
          clean_json = raw_response.to_s.gsub(/^```json\s*|\s*```$/, "")
          JSON.parse(clean_json)
        rescue JSON::ParserError
          { error: "Invalid JSON returned", raw_content: raw_response }
        end
      else
        raw_response
      end
    end
  end
end
