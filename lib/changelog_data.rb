require 'yaml'

class ChangelogData
  CHANGE_KINDS = {
    'feature' => { label: 'Feature', dot: 'bg-green-500' },
    'fix' => { label: 'Fixed', dot: 'bg-red-500' },
    'chore' => { label: 'Chore', dot: 'bg-gray-500' },
    'security' => { label: 'Security', dot: 'bg-yellow-500' }
  }.freeze

  def self.releases
    @releases ||= load_releases
  end

  def self.load_releases
    path = File.join(File.dirname(__FILE__), '..', 'config', 'changelog.yml')
    data = YAML.load_file(path)
    data.fetch('releases', [])
  rescue StandardError => e
    puts "Warning: Could not load changelog from #{path}: #{e.message}"
    []
  end

  def self.kind_for(kind)
    CHANGE_KINDS.fetch(kind, { label: kind.to_s.capitalize, dot: 'bg-gray-500' })
  end

  def self.format_change_text(text)
    text.gsub(/`([^`]+)`/) do
      %(<code class="text-xs bg-gray-100 dark:bg-zinc-800 px-1 py-0.5 rounded">#{$1}</code>)
    end.html_safe
  end
end
