module PageSchemas
  # 1. ATOMIC COMPONENT: Hero Heading
  # This acts as the "leaf" node of your schema tree.
  HERO_HEADING_SCHEMA = {
    type: "object",
    properties: {
      content: { type: "string", description: "The main bold headline text" }
    },
    required: [ "content" ]
  }

  HERO_SUBHEADING_SCHEMA = {
    type: "object",
    properties: {
       content: { type: "string", description: "Subheading for the hero section " }
      }
   }
end
