# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :o_auth_credential do
    user
    uid { Time.now.to_s }

    factory :facebook_credential do
      provider "facebook"
    end
    factory :twitter_credential do
      provider "twitter"
    end
    factory :github_credential do
      provider "github"
    end
  end
end
