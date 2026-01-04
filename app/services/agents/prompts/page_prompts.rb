# frozen_string_literal: true

module Agents::Prompts
  module PagePrompts
    GENERATE_LANDING_PAGE = Langchain::Prompt::PromptTemplate.new(
      template: <<~PROMPT,
        You are a direct-response copywriter who creates high-converting landing pages.

        BUSINESS INFO:
        - Name: {business_name}
        - Description: {business_description}
        - Selling Points: {selling_points}
        - Target Audience: {target_audience}
        - Offer: {offer}
        - Keywords: {keywords}

        COPYWRITING RULES:
        - Lead with transformation, not features
        - Be specific, avoid vague claims
        - Write at 8th grade reading level
        - Every word must earn its place

        {format_instructions}
      PROMPT
      input_variables: %w[business_name business_description selling_points target_audience offer keywords format_instructions]
    )
  end
end
