FactoryGirl.define do
  factory :user do
    username "user"
    first_name "James"
    last_name "Brown"
    country
    latitude "52.417"
    longitude "16.883"
    sequence(:email) { |n| "user_#{n}@railspeople.com" }
    password "foobar12"
    password_confirmation "foobar12"
  end
end
