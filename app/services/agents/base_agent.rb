module Agents
  class BaseAgent
    def self.generate(prompt:, source: nil, schema: nil)
      llm = LangchainConfig.llm

      # Fill template with data from source
      full_prompt = format_prompt(prompt, source, schema)

      # Call LLM (force JSON response if schema provided)
      options = { messages: [ { role: "user", content: full_prompt } ] }
      options[:response_format] = { type: "json_object" } if schema
      raw_response = llm.chat(**options).chat_completion

      # Return parsed JSON or raw text
      schema ? JSON.parse(raw_response) : raw_response
    end

    def self.preview(prompt:, source: nil, schema: nil)
      format_prompt(prompt, source, schema)
    end

    def self.format_prompt(prompt, source, schema)
      data = source.business_details

      inputs = {}

      # Loop through each variable the prompt expects
      # e.g., ["business_name", "target_audience", "pain_point", "format_instructions"]
      prompt.input_variables.each do |var|
        # Skip format_instructions, we add it separately
        next if var == "format_instructions"

        # Get value from business_details hash
        # Try symbol key first, then string key
        value = data[var] || data[var.to_s]

        # If value is array, convert to comma-separated string
        # ["ai powered", "high quality"] => "ai powered, high quality"
        value = value.join(", ") if value.is_a?(Array)

        # If key doesn't exist in data, use fallback
        value ||= "N/A"

        inputs[var.to_sym] = value
      end

      # Add schema as format_instructions so LLM knows the output structure
      inputs[:format_instructions] = schema ? "Respond with JSON:\n#{schema.to_json}" : ""

      # Replace {business_name} => "OneClickDrive", {target_audience} => "Tourists", etc.
      prompt.format(**inputs)
    end
  end
end
