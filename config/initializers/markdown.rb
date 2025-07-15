# ./config/initializers/markdown.rb

# Restart the server to see changes made to this file.
# You should read the docs at https://github.com/vmg/redcarpet and probably
# delete a bunch of stuff below if you don't need it.

require 'liquid'
require_relative '../../liquid/liquid'

Liquid::Environment.default.error_mode = :strict

class ApplicationMarkdown < MarkdownRails::Renderer::Rails
  # Reformats your boring punctation like " and " into “ and ” so you can look
  # and feel smarter. Read the docs at https://github.com/vmg/redcarpet#also-now-our-pants-are-much-smarter
  include Redcarpet::Render::SmartyPants

  # Run `bundle add rouge` and uncomment the include below for syntax highlighting
  include MarkdownRails::Helper::Rouge

  # If you need access to ActionController::Base.helpers, you can delegate by uncommenting
  # and adding to the list below. Several are already included for you in the `MarkdownRails::Renderer::Rails`,
  # but you can add more here.
  #
  # To see a list of methods available run `bin/rails runner "puts ActionController::Base.helpers.public_methods.sort"`
  #
  # delegate :request, :cache, :turbo_frame_tag, to: :helpers

  # Override render to pre-process with Liquid
  # def render(text)
  #   # Pre-process with Liquid
  #   liquid_template = Liquid::Template.parse(text)
  #   liquid_result = liquid_template.render(liquid_context.stringify_keys)
  #   # Call the parent render method with the processed text
  #   super(liquid_result)
  # end

  # These flags control features in the Redcarpet renderer, which you can read
  # about at https://github.com/vmg/redcarpet#and-its-like-really-simple-to-use
  # Make sure you know what you're doing if you're using this to render user inputs.
  def enable
    [:fenced_code_blocks, :tables, :hard_wrap]
  end

  def block_code(code, language)
    content_tag :pre, class: language do
      content_tag :code do
        raw highlight_code code, language
      end
    end
  end

  def header(text, header_level)
    return "<h1>#{text}</h1>" if header_level == 1

    id = text.parameterize
    <<-HTML
      <h#{header_level} id="#{id}" class="scroll-mt-20">
        #{text}
      </h#{header_level}>
    HTML
  end

  def preprocess(full_document)
    liquid_template = Liquid::Template.parse(full_document, environment: liquid_environment, error_mode: :lax)
    liquid_template.render({}, registers: { markdown_renderer: self.renderer })
  end

  def postprocess(full_document)
    full_document.gsub("\\<br>", "<br>")
  end

  def renderer
    ::Redcarpet::Markdown.new(self.class.new(**features), **features)
  end

  private

  def liquid_environment
    @liquid_environment ||= Liquid::Environment.build do |environment|
      environment.register_tag('hint', Liquid::Tags::HintTag)
      environment.register_tag('code', Liquid::Tags::CodeTag)
      environment.register_tag('description', Liquid::Tags::DescriptionTag)
    end
  end
end

# Setup markdown stacks to work with different template handler in Rails.
MarkdownRails.handle :md, :markdown do
  ApplicationMarkdown.new
end
