# config/initializers/devise_patch.rb
require 'devise/version'
if !defined?(Devise::VERSION) || (Devise::VERSION < "1.4.0" && %w[1.2 1.3].all? {|v| !Devise::VERSION.start_with?(v)})
raise "I don't know how to patch your devise version. See http://blog.plataformatec.com.br/2013/01/security-announcement-devise-v2-2-3-v2-1-3-v2-0-5-and-v1-5-3-released/"
end
 
if Devise::VERSION < "1.5.0"
warn "Patching devise #{Devise::VERSION} with < 1.5.0 patch"
Devise::Models::Authenticatable::ClassMethods.class_eval do
def auth_param_requires_string_conversion?(value); true; end
end
elsif [("1.5.0".."1.5.3"), ("2.0.0".."2.0.4"), ("2.1.0".."2.1.2"), ("2.2.0".."2.2.2")].any? { |range|
range.include?(Devise::VERSION)
}
warn "Patching devise #{Devise::VERSION} with < 2.2.3 patch"
Devise::ParamFilter.class_eval do
def param_requires_string_conversion?(_value); true; end
end
end