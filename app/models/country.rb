class Country < ActiveRecord::Base

  belongs_to :user
  # def self.find_by(property, value)
  #   COUNTRIES_LIST.each do |country|
  #     return country if country[property.to_sym] == value
  #   end
  # end

  # def self.all
  #   COUNTRIES_LIST
  # end

  # def self.names
  #   ret = []
  #   COUNTRIES_LIST.each do |country|
  #     ret << country[:name]
  #   end
  #   ret
  # end
  
  # def self.printable_names
  #   ret = []
  #   COUNTRIES_LIST.each do |country|
  #     ret << country[:printable_name]
  #   end
  #   ret
  # end
end
