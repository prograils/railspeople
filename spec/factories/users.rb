FactoryGirl.define do
  factory :user do
    #sequence(:name) { |n| "name_#{n}" }
    #sequence(:surname) { |n| "surname_#{n}" }
    #sequence(:username) { |n| "User #{n}" }
    country "Poland"
    latitude "1"
    longitude "2"
    sequence(:email) { |n| "user_#{n}@railspeople.com" }
    password "foobar12"
    password_confirmation "foobar12"
    #is_admin false
    #after(:create) { |u| u.confirm! }
  end

  #
  #factory :admin, :parent => :user do
  #  sequence(:username) { |n| "admin #{n}" }
  #  sequence(:email) { |n| "admin_#{n}@najsdokop.pl" }
  #  is_admin true
  #end
end