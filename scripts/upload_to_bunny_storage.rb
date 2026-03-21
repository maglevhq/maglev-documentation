#!/usr/bin/env ruby

require 'net/http'
require 'uri'
require 'pathname'

class BunnyStorageUploader
  STORAGE_HOST = 'storage.bunnycdn.com'.freeze

  def initialize(source_dir:, storage_zone_name:, access_key:)
    @source_dir = File.expand_path(source_dir)
    @storage_zone_name = storage_zone_name
    @access_key = access_key
  end

  def upload_all
    raise "Source directory not found: #{@source_dir}" unless Dir.exist?(@source_dir)

    files = Dir.glob(File.join(@source_dir, '**', '*')).select { |path| File.file?(path) }
    puts "Uploading #{files.size} files from #{@source_dir}"

    files.each_with_index do |path, index|
      rel_path = Pathname.new(path).relative_path_from(Pathname.new(@source_dir)).to_s
      remote_path = build_remote_path(rel_path)
      upload_file(path, remote_path)
      puts "[#{index + 1}/#{files.size}] Uploaded #{rel_path}"
    end
  end

  private

  def build_remote_path(rel_path)
    rel_path.tr('\\', '/').sub(%r{\A/+}, '')
  end

  def upload_file(local_path, remote_path)
    encoded_path = remote_path.split('/').map { |segment| URI.encode_www_form_component(segment) }.join('/')
    uri = URI("https://#{STORAGE_HOST}/#{@storage_zone_name}/#{encoded_path}")
    body = File.binread(local_path)

    request = Net::HTTP::Put.new(uri)
    request['AccessKey'] = @access_key
    request['Content-Type'] = 'application/octet-stream'
    request.body = body

    response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    return if response.is_a?(Net::HTTPSuccess)

    raise "Upload failed for #{local_path} -> #{uri} (#{response.code} #{response.message}): #{response.body}"
  end
end

def required_env!(name)
  value = ENV[name]
  raise "Missing environment variable: #{name}" if value.nil? || value.strip.empty?

  value
end

source_dir = ARGV[0] || 'build'

uploader = BunnyStorageUploader.new(
  source_dir: source_dir,
  storage_zone_name: required_env!('BUNNY_STORAGE_ZONE_NAME'),
  access_key: required_env!('BUNNY_STORAGE_ZONE_PASSWORD')
)

uploader.upload_all
puts 'Upload finished.'
