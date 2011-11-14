class Sponsor
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name, :type => String
  field :description, :type => String
  field :address, :type => String
  field :phone, :type => String
  field :url, :type => String
  field :img_name, :type => String
  field :created_at, :type => DateTime
  field :updated_at, :type => DateTime
  field :logo_file_name, :type => String
  field :logo_content_type, :type => String
  field :logo_file_size, :type => Integer
  field :logo_updated_at, :type => DateTime
  field :logo_style, :type => String

  has_and_belongs_to_many :locations
  
end
