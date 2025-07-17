# ./config/initializers/markdown.rb

# Restart the server to see changes made to this file.
# You should read the docs at https://github.com/vmg/redcarpet and probably
# delete a bunch of stuff below if you don't need it.

require 'liquid'
require_relative '../../liquid/liquid'

Liquid::Environment.default.error_mode = :strict

class ApplicationMarkdown < MarkdownRails::Renderer::Rails
  attr_reader :tabs_html

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
      <h#{header_level} id="#{id}" class="scroll-mt-20 relative group/hash flex items-center">
        <div class="-ml-8 pr-2 relative group-hover/hash:opacity-100 opacity-0 transition-opacity">
          <a href="##{id}" class="text-gray-400 group-hover/hash:text-gray-600 transition-colors">
            <i class="fa-solid fa-hashtag"></i>
          </a>
        </div>
        <span>#{text}</span>
      </h#{header_level}>
    HTML
  end

  def preprocess(full_document)
    reset_tabs_html
    liquid_template = Liquid::Template.parse(full_document, environment: liquid_environment, error_mode: :lax)
    liquid_template.render({},
      registers: {
        markdown_renderer: self.renderer,
        tabs_html: tabs_html
      }
    )
  end

  def postprocess(full_document)
    full_document.gsub!("\\<br>", "<br>")
    tabs_html.each_with_index do |html, index|
      full_document.gsub!("<!-- tabs##{index} -->", html)
    end
    # Add data-controller="copy-code" to all <code> tags
    full_document.gsub!(/<code(?![^>]*data-controller)/, '<code data-controller="copy-code"')
    full_document
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
      environment.register_tag('tabs', Liquid::Tags::TabsTag)
      environment.register_tag('tab', Liquid::Tags::TabTag)
    end
  end

  def reset_tabs_html
    @tabs_html = []
  end
end

# Setup markdown stacks to work with different template handler in Rails.
MarkdownRails.handle :md, :markdown do
  ApplicationMarkdown.new
end
