# TODO: Wrap the schema lib under ai-agents
# So we can extend it as Agents::Schema
if defined?(RubyLLM)
  class Captain::ResponseSchema < RubyLLM::Schema
    string :response, description: 'The message to send to the user'
    string :reasoning, description: "Agent's thought process"
  end
else
  # Stub class when RubyLLM is not available
  class Captain::ResponseSchema
  end
end
