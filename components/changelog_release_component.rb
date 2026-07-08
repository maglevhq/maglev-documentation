class ChangelogReleaseComponent < ViewComponent::Base
  attr_reader :release

  def initialize(release:)
    @release = release
  end

  def version
    "v#{release['version']}"
  end

  def date
    release['date']
  end

  def latest?
    release['latest']
  end

  def yanked?
    release['yanked']
  end

  def summary
    release['summary']
  end

  def changes
    release.fetch('changes', [])
  end

  def header_classes
    if latest?
      'border-b border-gray-200 dark:border-zinc-700 bg-green-50 dark:bg-green-950/30'
    elsif yanked?
      'border-b border-gray-200 dark:border-zinc-700 bg-red-50 dark:bg-red-950/30'
    else
      'border-b border-gray-200 dark:border-zinc-700 bg-gray-50 dark:bg-zinc-800/50'
    end
  end

  def version_badge_classes
    if latest?
      'bg-green-100 dark:bg-green-900/50 text-green-700 dark:text-green-300 ring-green-600/20'
    elsif yanked?
      'bg-red-100 dark:bg-red-900/50 text-red-700 dark:text-red-300 ring-red-600/20'
    else
      'bg-gray-100 dark:bg-zinc-800 text-gray-700 dark:text-zinc-300 ring-gray-600/20'
    end
  end

  def date_classes
    if latest?
      'text-green-700 dark:text-green-300'
    elsif yanked?
      'text-red-700 dark:text-red-300'
    else
      'text-gray-600 dark:text-zinc-400'
    end
  end

  def change_kind(change)
    ChangelogData.kind_for(change['kind'])
  end

  def formatted_change_text(text)
    ChangelogData.format_change_text(text)
  end
end
