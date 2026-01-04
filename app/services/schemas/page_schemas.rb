module Schemas
  module PageSchemas
    # ==========================================
    # 1. HERO SECTION
    # Goal: Grab attention immediately (Hook) and bridge to solution (Stabilizer)
    # ==========================================

    HERO_HOOK_SCHEMA = {
      type: "object",
      properties: {
        content: {
          type: "string",
          description: "The 'Big Promise'. A punchy, benefit-driven headline that addresses the client's main pain point. Avoid generic welcomes."
        }
      },
      required: [ "content" ],
      additionalProperties: false
    }.freeze

    HERO_HOOK_STABILIZER_SCHEMA = {
      type: "object",
      properties: {
        content: {
          type: "string",
          description: "The 'Stabilizer'. A 2-3 sentence elaboration that validates the headline, reduces skepticism, and creates a bridge to the solution."
        }
      },
      required: [ "content" ],
      additionalProperties: false
    }.freeze

    HERO_ACTIONS_SCHEMA = {
      type: "object",
      properties: {
        primary_cta: {
          type: "string",
          description: "High-commitment action text (e.g., 'Book Consultation', 'Start Now'). Must use strong verbs."
        },
        secondary_cta: {
          type: "string",
          description: "Low-commitment action text (e.g., 'Learn More', 'View Pricing'). For users not ready to buy yet."
        }
      },
      required: [ "primary_cta", "secondary_cta" ],
      additionalProperties: false
    }.freeze

    # COMPOSITE: Hero Section
    # Fixed: Mapped 'headline' to HERO_HOOK_SCHEMA and 'subheadline' to HERO_HOOK_STABILIZER_SCHEMA
    HERO_SECTION_SCHEMA = {
      type: "object",
      properties: {
        headline: HERO_HOOK_SCHEMA,
        subheadline: HERO_HOOK_STABILIZER_SCHEMA,
        actions: HERO_ACTIONS_SCHEMA
      },
      required: [ "headline", "subheadline", "actions" ],
      additionalProperties: false
    }.freeze

    # ==========================================
    # 2. TESTIMONIALS & SOCIAL PROOF
    # Goal: Build authority and relatability
    # ==========================================

    TESTIMONIALS_HEADING_SCHEMA = {
      type: "object",
      properties: {
        content: { type: "string", description: "The main bold headline text for the social proof section." }
      },
      required: [ "content" ],
      additionalProperties: false
    }.freeze

    TESTIMONIALS_SUBHEADING_SCHEMA = {
      type: "object",
      properties: { # Fixed typo: 'proprties' -> 'properties'
        content: { type: "string", description: "The subheading reinforcing trust and belonging." }
      },
      required: [ "content" ],
      additionalProperties: false
    }.freeze

    TESTIMONIALS_SECTION_SCHEMA = {
      type: "object",
      properties: {
        heading: TESTIMONIALS_HEADING_SCHEMA,
        subheading: TESTIMONIALS_SUBHEADING_SCHEMA
      },
      required: [ "heading", "subheading" ],
      additionalProperties: false
    }.freeze

    # ==========================================
    # 3. BELOW THE FOLD (Agitation)
    # Goal: Amplify the problem to create empathy
    # ==========================================

    BELOW_FOLD_HOOK_SCHEMA = {
      type: "object",
      properties: {
        content: { type: "string", description: "A hook that emotionally amplifies the user's specific problem." }
      },
      required: [ "content" ],
      additionalProperties: false
    }.freeze

    BELOW_FOLD_TEXT_SCHEMA = {
      type: "object",
      properties: {
        content: { type: "string", description: "Empathic copy that validates the user's struggle and prepares them for the upcoming solution." }
      },
      required: [ "content" ],
      additionalProperties: false
    }.freeze

    BELOW_FOLD_SECTION_SCHEMA = {
      type: "object",
      properties: {
        hook: BELOW_FOLD_HOOK_SCHEMA,
        text: BELOW_FOLD_TEXT_SCHEMA
      },
      required: [ "hook", "text" ],
      additionalProperties: false
    }.freeze

    # ==========================================
    # 4. SERVICES SECTION
    # Goal: Explain the solution
    # ==========================================

    SERVICES_HEADING_SCHEMA = {
      type: "object",
      properties: {
        content: { type: "string", description: "Title for the services or solution section." }
      },
      required: [ "content" ],
      additionalProperties: false
    }.freeze

    SERVICES_SUBHEADING_SCHEMA = {
      type: "object",
      properties: {
        content: { type: "string", description: "Subtitle explaining the scope of services." }
      },
      required: [ "content" ],
      additionalProperties: false
    }.freeze

    SERVICES_SECTION_SCHEMA = {
      type: "object",
      properties: {
        heading: SERVICES_HEADING_SCHEMA,
        subheading: SERVICES_SUBHEADING_SCHEMA # Fixed typo: SHCEMA
      },
      required: [ "heading", "subheading" ],
      additionalProperties: false
    }.freeze

    # ==========================================
    # 5. OFFER SECTION
    # Goal: The pitch and final call to action
    # ==========================================

    OFFER_HEADING_SCHEMA = {
      type: "object",
      properties: {
        content: { type: "string", description: "Headline for the irresistible offer." }
      },
      required: [ "content" ],
      additionalProperties: false
    }.freeze

    OFFER_SUBHEADING_SCHEMA = {
      type: "object",
      properties: {
        content: { type: "string", description: "Value proposition summary of the offer." }
      },
      required: [ "content" ],
      additionalProperties: false
    }.freeze

    OFFER_BENEFIT_SCHEMA = {
      type: "object",
      properties: {
        content: { type: "string", description: "A single core benefit of the offer." }
      },
      required: [ "content" ],
      additionalProperties: false
    }.freeze

    OFFER_BENEFITS_SCHEMA = { # Fixed typo: SCEHMA -> SCHEMA
      type: "array",
      items: OFFER_BENEFIT_SCHEMA, # Fixed logic: Referenced the actual schema above
      description: "List of core benefits included in the offer."
    }.freeze

    OFFER_CALL_TO_ACTION_SCHEMA = {
      type: "object",
      properties: {
        content: { type: "string", description: "Final persuasive text for the call to action button." }
      },
      required: [ "content" ],
      additionalProperties: false
    }.freeze

    OFFER_SECTION_SCHEMA = {
      type: "object",
      properties: {
        heading: OFFER_HEADING_SCHEMA,
        subheading: OFFER_SUBHEADING_SCHEMA, # Fixed typo: SHCEMA
        benefits: OFFER_BENEFITS_SCHEMA,
        call_to_action: OFFER_CALL_TO_ACTION_SCHEMA
      },
      required: [ "heading", "subheading", "benefits", "call_to_action" ],
      additionalProperties: false
    }.freeze


    LANDING_PAGE_SCHEMA = {
      type: "object",
      properties: {
        hero_section: HERO_SECTION_SCHEMA,
        testimonials_section: TESTIMONIALS_SECTION_SCHEMA,
        below_fold_section: BELOW_FOLD_SECTION_SCHEMA,
        services_section: SERVICES_SECTION_SCHEMA,
        offer_section: OFFER_SECTION_SCHEMA
      },
      required: [
        "hero_section",
        "testimonials_section",
        "below_fold_section",
        "services_section",
        "offer_section"
      ],
      additionalProperties: false,
      description: "A complete, high-converting landing page structure containing all necessary marketing sections."
    }.freeze
  end
end
