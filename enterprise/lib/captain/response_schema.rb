# TODO: Wrap the schema lib under ai-agents
# So we can extend it as Agents::Schema
# Only define if RubyLLM is available (AI features enabled)
if defined?(RubyLLM)
  class Captain::ResponseSchema < RubyLLM::Schema
    string :response, description: 'The message to send to the user'
    string :reasoning, description: "Agent's thought process"
  end
end
