class Backend::ResourceController < Backend::ApplicationController
  inherit_resources
  respond_to :html
  has_scope :page, default: 1

  self.responder = Backend::Responder
#  def index
#    @a = []
#    resource_class.all.collect { |r| r.fields.keys.each { |k| @a << k } }
#    @a.uniq - %w(_id _type created_at updated_at encrypted_password)
#  end
end
