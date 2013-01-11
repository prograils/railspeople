# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :blog do
    user
    title "wp"
    url "http://www.wp.pl"
  end
end
