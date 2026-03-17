require 'dotenv/load'

desc "Remove all files from the build directory"
task :clean do
  sh 'rm -rf ./build'
end

desc "Compile the sitepress site"
task :compile do
  sh 'npx @tailwindcss/cli -i ./assets/stylesheets/site.source.css -o ./assets/stylesheets/site.css --minify'
  sh 'yarn esbuild ./assets/javascripts/site.source.js --bundle --outfile=./assets/javascripts/site.js --minify'
  sh 'bundle exec ./scripts/generate_search_index.rb'
  sh 'bundle exec sitepress compile'
  sh "mv ./build/404/index.html ./build/404.html"
  sh "rm -rf ./build/404"
  sh 'bundle exec ./scripts/generate_llm_markdown.rb'
  Rake::Task[:compile_sitemap].invoke
end

desc "Compile the sitemap"
task :compile_sitemap do
  require_relative './lib/sitemap.rb'
  Sitemap.compile(path: Dir.getwd, base_url: ENV['SITE_BASE_URL'])
end

desc "Upload build directory to Bunny Storage"
task :publish do
  sh 'bundle exec ruby ./scripts/upload_to_bunny_storage.rb ./build'
end

desc "Purge cache from the CDN"
task :purge_cache do
  require_relative './lib/bunnycdn.rb'

  client = Bunnycdn.new(access_key: ENV['BUNNY_ACCESS_KEY'])
  client.purge(ENV['BUNNY_ZONE_ID'])
end

task default: %w[clean compile publish purge_cache]
