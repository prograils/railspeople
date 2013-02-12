FactoryGirl.define do
  factory :country do
    sequence(:name) { |n| "COUNTRY ##{n}" }
    sequence (:printable_name) { |n| "Country ##{n}" }  
    sequence (:iso) { |n| "PL" }  
    sequence (:iso3) { |n| "PL-#{n}" }  
    sequence (:lat) { |n| "1.1#{n}" }  
    sequence (:lng) { |n| "2.2#{n}" }  
  end
end
