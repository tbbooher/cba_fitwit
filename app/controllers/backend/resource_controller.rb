class Backend::ResourceController < Backend::ApplicationController
  inherit_resources
  #before_filter :authenticate_user!
  respond_to :html
  has_scope :page, default: 1

  self.responder = Backend::Responder
  #def index
    #attributes = resource_class.all.collect { |r| r.fields.keys} - %w(_id _type created_at updated_at encrypted_password)
  #end

end
