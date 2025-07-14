class AppLayout::TopbarComponent < ViewComponent::Base
  include SettingsHelper

  renders_one :links
end
