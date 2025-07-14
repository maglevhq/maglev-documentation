class AppLayout::SidebarComponent < ViewComponent::Base
  include PageHelper

  attr_reader :site, :current_page

  def initialize(site:, current_page:)
    @site = site
    @current_page = current_page
  end

  def pages
    site.root.children.map do |node|
      Page.build(node)
    end.sort_by(&:order).unshift(Page.build(site.root, recursive: false))
  end

  class Page
    attr_reader :title, :path, :order, :children, :resource

    def initialize(title:, path:, resource:,order: Float::INFINITY)
      @title = title
      @path = path
      @resource = resource
      @order = order
      @children = []
    end

    def children?
      children.any?
    end

    def append_child(child)
      children << child
    end

    def sort_children!
      children.sort_by!(&:order)
    end

    def self.build(node, recursive: true)
      resource = node.resources.first
      data = resource.data
      path = resource.data['redirect_to'] ? nil : resource.request_path

      new(
        title: data.fetch("title", File.basename(resource.request_path)),
        path: path,
        resource: resource,
        order: data.fetch("order", Float::INFINITY)
      ).tap do |page|
        if recursive
          node.children.each do |child|
            page.append_child(Page.build(child))
          end
          page.sort_children!
        end
      end
    end
  end
end
