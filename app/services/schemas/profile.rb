module Agents
  module Schemas
    module Profile
      # We define the schema inside the 'Profile' module
      DEFINITION = {
        type: "object",
        properties: {
          name: { type: "string" },
          skills: { type: "array", items: { type: "string" } }
        },
        required: ["name", "skills"]
      }.freeze
    end
  end
end
