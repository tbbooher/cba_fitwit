class Backend::ResourceController < Backend::ApplicationController
  inherit_resources
  before_filter :verify_admin
  respond_to :html
  has_scope :page, default: 1

  self.responder = Backend::Responder
  #def index
    #attributes = resource_class.all.collect { |r| r.fields.keys} - %w(_id _type created_at updated_at encrypted_password)
  #end

  private

  def verify_admin
    flash[:notice] = "Only administrators can access the FitWit Admin Interface"
    redirect_to root_url unless (current_user && current_user.admin?)
  end

end
