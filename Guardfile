# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'pow' do
  watch('app.rb')
  watch('app/routes.rb')
  watch('config/environment.rb')
  watch(%r{^app/controllers/.*\.rb$})
  watch(%r{^app/models/.*\.rb$})
end

guard 'livereload' do
  watch(%r{app/views/.+\.(erb|haml|slim)$})
  watch(%r{app/helpers/.+\.rb})
  watch(%r{public/.+\.(css|js|html)})
  watch(%r{config/locales/.+\.yml})
  # Rails Assets Pipeline
  watch(%r{(app|vendor)(/assets/\w+/(.+\.(css|js|html))).*}) { |m| "/assets/#{m[3]}" }
end
