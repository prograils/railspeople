FactoryGirl.define do
  factory :user do
    country "Poland"
    latitude "1.237846"
    longitude "2.43248"
    sequence(:email) { |n| "user_#{n}@railspeople.com" }
    password "foobar12"
    password_confirmation "foobar12"
  end
end
