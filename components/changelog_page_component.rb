require_relative '../lib/changelog_data'

class ChangelogPageComponent < ViewComponent::Base
  def releases
    ChangelogData.releases
  end
end
