Dir[Rails.root.join(File.expand_path('../features', __FILE__), "*.rb")].each {|f| require f}
RSpec.configure do |config|
  config.include Features::SessionHelpers, type: :feature
end