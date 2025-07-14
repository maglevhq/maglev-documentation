class AppLayoutComponent < ViewComponent::Base
  attr_reader :site, :current_page

  renders_many :topbar_links, 'AppLayout::TopbarLinkComponent'

  def initialize(site:, current_page:)
    @site = site
    @current_page = current_page
  end
end
