class Organization < ActiveResource::Base
  self.site = 'https://api.github.com'
  self.include_format_in_path = false
end

class OrganizationEntity < Dao::Entity::Base
  attribute :id,        Integer
  attribute :name,      String
  attribute :full_name, String
end
