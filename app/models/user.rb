# -*- encoding : utf-8 -*-

# This is a Device-User-Class extended with ROLES, Avatar-handling, and more
class User
  include Mongoid::Document
  include Mongoid::Spacial::Document # GeoIndex
  include Mongoid::Timestamps
  include Mongoid::Paperclip
  include Mongoid::MultiParameterAttributes

  cache

  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # fitwit fields

  field :name
  field :roles_mask, :type => Fixnum, :default => 0
  field :use_gravatar, :type => Boolean, :default => true
  field :invitation_id, :type => BSON::ObjectId

  # later fields
  field :contract_months, type: Integer
  field :sessions_per_week, type: Integer
  field :monthly_price, type: Money # in cents
  field :start_date_for_contract, type: Date
  field :end_date_for_contract, type: Date
  field :last_charge_date, type: Date
  field :notes, type: String
  field :payment_method, type: String
  field :paid_in_full, type: Boolean
  field :on_pause, type: Boolean
  field :total_value_of_contract, type: Money

  field :first_name, type: String
  field :last_name, type: String
  field :gender, type: Symbol, default: :male
  field :occupation, type: String
  field :company, type: String
  field :street_address1, type: String
  field :street_address2, type: String
  field :city, type: String
  field :us_state, type: String
  field :zip, type: String
  field :primary_phone, type: String
  field :secondary_phone, type: String
  field :t_shirt_size, type: String
  field :emergency_contact_name, type: String
  field :emergency_contact_relationship, type: String
  field :emergency_contact_phone, type: String
  field :weight, :type => Integer
  field :how_did_you_hear_about_us
  field :fitness_level, :type => Integer
  field :date_of_birth, :type => Date
  field :height_inches, :type => Integer
  field :height_feet, :type => Integer
  field :veteran_status, type: Symbol, default: :newbie # [:veteran, :supervet, :newbie, :staff]
  field :number_of_logins, :type => Integer
  field :member, :type => Boolean
  field :why_i_fitwit, type: String
  field :when_started_fitwit, type: Date
  field :reset_password_sent_at, type: Time

  # approvals
  field :has_physician_approval, type: Boolean, default: false
  field :has_physician_approval_explanation, type: String
  field :meds_affect_vital_signs, type: Boolean, default: true
  field :meds_affect_vital_signs_explanation, type: String

  # female specific
  field :post_menopausal_female, type: Boolean, default: false
  field :taking_estrogen, type: Boolean, default: false

  attr_accessible :health_issues_attributes

  accepts_nested_attributes_for :health_issues, autosave: true, allow_destroy: true # , reject_if: lambda {|a| a['has_it'] == "0" && a['explanation'].blank? }, allow_destroy: true

  # fitwit
  # validates_numericality_of :weight, :height_feet, :height_inches
  # validates_format_of :primary_phone, :with => /[0-9\-\.]+/i

  # TODO get validations working
  #validates_multiparameter_assignments :message => " is not entered correctly."

  #validates_uniqueness_of :user_name

  GENDER = [
  #  Displayed        stored in db
  ["male", :male],
  ["female", :female]
  ]

  # [:veteran, :supervet, :newbie, :staff]
  VETERAN_STATUS = [
          # DISP              # IN DB
  ['No previous camps', :newbie], # no vet
  ['One to three camps', :veteran], # vet
  ['Four or more camps', :supervet] #super-vet
  ]

  TSHIRT_SIZES = [
          #  Displayed        stored in db
  ["Small", :s],
  ["Medium", :m],
  ["Large", :l],
  ["Extra Large", :xl]
  ]

  def as_csv
      {"Camper" => self.full_name,
       "Contact Name" => self.emergency_contact_name,
       "Relationship" => self.emergency_contact_relationship,
       "Phone" => self.primary_phone,
       "Health Report" => self.short_health_state}
  end

  # end !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

  def monthly_price=(dollars)
    write_attribute(:monthly_price, dollars.to_money)
  end

  def total_value_of_contract=(dollars)
    write_attribute(:total_value_of_contract, dollars.to_money)
  end

  def user_name
    self.name
  end

  def birthday_string
    if self.date_of_birth
      date_of_birth.to_s(:db)
    else
      ""
    end
  end

  def birthday_string=(birthday_string)
    self.date_of_birth = Date.parse(birthday_string)
  rescue ArgumentError
    @birthday_invalid = true
  end

  def invitation
    @invitation ||= Invitation.criteria.for_ids(self.invitation_id).first
  end

  def invitation=(inv)
    @invitation = nil
    self.invitation_id = inv.id
  end

  field :gis_location, type: Array, spacial: true

  def articles
    []
  end

  references_many :authentications, :dependent => :delete
  references_many :postings, :dependent => :delete
  references_many :invitations, :dependent => :delete

  embeds_many :user_notifications
  embeds_many :user_groups
  has_many    :articles

  # FitWit Specifics
  has_many :workouts, :dependent => :destroy
  has_many :orders, :dependent => :destroy
  has_many :registrations, :dependent => :destroy

  has_and_belongs_to_many :attendances, class_name: "Meeting", inverse_of: :attendees

  belongs_to :location

  embeds_many :user_prs
  embeds_many :custom_workouts
  embeds_many :goals
  embeds_many :measurements
  embeds_many :health_issues # , autosave: true

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: {case_sensitive: false}, :email => true

  validates :gender, :inclusion => { :in => [:male, :female], :message => "%{value} is not a gender type" }
  validates :veteran_status, :inclusion => { :in => [:veteran, :supervet, :newbie, :staff], :message => "%{value} is not a valid veteran status" }
  validates :height_inches, :numericality => {:less_than_or_equal_to => 12}, allow_blank: true
  validates :height_feet, :numericality => {:less_than => 9}, allow_blank: true

  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :roles_mask,
                  :remember_me, :authentication_token, :confirmation_token,
                  :avatar, :clear_avatar, :crop_x, :crop_y, :crop_w, :crop_h,
                  :time_zone, :language, :use_gravatar, :invitation_id,
                  :gis_location_token, :secondary_phone, :emergency_contact_name,
                  :emergency_contact_relationship, :primary_phone, :gender,
                  :occupation, :company, :t_shirt_size, :date_of_birth, :street_address1,
                  :street_address2, :city, :us_state, :roles_mask, :zip, :secondary_phone,
                  :weight, :how_did_you_hear_about_us, :fitness_level, :height_inches,
                  :height_feet, :veteran_status, :member, :has_physician_approval,
                  :has_physician_approval_explanation, :post_menopausal_female,
                  :taking_estrogen, :location_id, :birthday_string, :health_issues_attributes,
                  :why_i_fitwit, :when_started_fitwit, :emergency_contact_phone, :contract_months,
                  :sessions_per_week,:monthly_price,:start_date_for_contract,
                  :end_date_for_contract,:last_charge_date,:notes,:payment_method,
                  :paid_in_full,:on_pause,:total_value_of_contract

  attr_accessor :clear_avatar

  has_mongoid_attached_file :avatar,
                            :storage => :s3,
                            :s3_credentials => S3_CREDENTIALS,
                            :path => ":attachment/:id/:style.:extension",
                            :styles => {
                              :popup  => "800x600=",
                              :medium => "300x300>",
                              :thumb  => "100x100>",
                              :icon   => "64x64"
                            },
                            :processors => [:cropper]
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  after_update  :reprocess_avatar, :if => :cropping?

  before_save :load_user_name

  # Notifications
  after_create   :async_notify_on_creation
  before_destroy :async_notify_on_cancellation
  before_update  :notify_if_confirmed

  # Authentications
  after_create :save_new_authentication
  after_create :first_user_hook

  # Roles - Do not change the order and do not remove roles if you
  # already have productive data! Thou it's safe to append new roles
  # at the end of the string. And it's safe to rename roles in place
  ROLES = [:guest, :confirmed_user, :author, :moderator, :maintainer, :admin]

  scope :with_role, lambda { |role| { :where => {:roles_mask.gte => ROLES.index(role) } } }

  scope :last_name_first, order_by([:last_name => :asc], [:first_name => :asc])
  scope :camps_than_name, order_by([:location_id => :asc], [:first_name => :asc])

  #def time_slots
  #  self.registrations.map(&:orders).map(&:time_slots)
  #end

  ###########################
  #                         #
  # FitWit Custom methods   #
  #                         #
  ###########################

  def self.member_info_to_csv
    CSV.generate do |csv|
      csv << ['name','location','contract months', 'sessions per week', 'start date', 'end date', 'last charge date', 'notes', 'payment_method', 'paid in full', 'total value', 'on pause', 'email', 'address', 'phone']
      all.each do |u|
        total_value = u.total_value_of_contract.dollars unless u.total_value_of_contract.nil?
        csv << [u.name,u.location_name,u.contract_months,u.sessions_per_week,u.start_date_for_contract,u.end_date_for_contract,u.last_charge_date,u.notes,u.payment_method, u.paid_in_full ? "T" : "F", total_value, u.on_pause ? "T" : "F",u.email, u.one_line_address, u.primary_phone]
      end
    end
  end

  def self.all_fitwit_users_info_to_csv
    CSV.generate do |c|
      c << ["name", "location", "email", "address", "phone", "camps_completed","previous"]
      all.each do |u|
        c << [u.name, u.location_name, u.email, u.one_line_address, u.primary_phone, 'camps completed', 'previous']
      end
    end
  end

  include FitWitCustomUserMethods

  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  def avatar_geometry(style = :original)
    paperclip_geometry avatar, style
  end

  def new_avatar?
    if avatar.updated_at && ((Time::now() - Time::at(self.avatar.updated_at)) < 1.minute)
      self.use_gravatar = false
      save
      true
    else
      false
    end
  end

  def admin?
    User.all.any? ? (self == User.first || role?(:admin)) : true
  end

  def role=(role)
    self.roles_mask = ROLES.index(role)
    Rails.logger.warn("SET ROLES TO #{self.roles_mask} FOR #{self.inspect}")
  end

  # return user's role as symbol.
  def role
    self.roles_mask = 0 if self.roles_mask < 0 || self.roles_mask >= ROLES.count
    self.roles_mask ? ROLES[self.roles_mask].to_sym : guest
  end

  # Ask if the user has at least a specific role.
  #   @user.role?('admin')
  def role?(role)
    self.roles_mask >= ROLES.index(role.to_sym)
  end

  # virtual attribute needed for the view but is false always.
  def clear_avatar
    false
  end

  # clear a previous uploaded avatar-image.
  def clear_avatar=(new_value)
    self.avatar = nil if new_value == '1'
  end

  # fetch attributes from the omniauth-record.
  def apply_omniauth(omniauth)
    if omniauth['provider'] == 'twitter'
      t_first_name, t_last_name = omniauth['info']['name'].split(' ', 2)
      oa_first_name =  first_name.blank? ? t_first_name : first_name
      oa_last_name = last_name.blank? ? t_last_name : last_name
      #flash[:notice] = "Twitter does not provide us with your email address." if self.email.blank?
    else
      oa_first_name =  first_name.blank? ? omniauth['info']['first_name'] : first_name
      oa_last_name = last_name.blank? ? omniauth['info']['last_name'] : last_name
      self.email = omniauth['info']['email'] if email.blank?
    end
    self.first_name = oa_first_name
    self.last_name = oa_last_name
    apply_trusted_services(omniauth) if self.new_record?
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
  end

  # remove the password and password-confirmation attribute if not needed.
  def update_with_password(params={})
    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end
    super
  end

  # @return String - the URL of the local avatar or the gravatar
  def avatar_url(mode)
    if self.use_gravatar
      "http://gravatar.com/avatar/#{gravatar_id}.png?cache=#{self.updated_at.strftime('%Y%m%d%H%M%S')}"
    else
      avatar.url(mode)
    end
  end

  # Link to the gravatar profile
  def gravatar_profile
    if self.use_gravatar
      "http://gravatar.com/#{gravatar_id}"
    end
  end

  def gis_location_token
    if self.gis_location[:lat].present? && self.gis_location[:lng].present?
      "%3.4f,%3.4f" % [self.gis_location[:lat], self.gis_location[:lng]]
    end
  end

  def gis_location_token=(str)
    coordinates = str.split(",").map! { |a| a.strip.gsub(/\(|\)/,'') }
    self.gis_location = {
      lat: coordinates[0].to_f,
      lng: coordinates[1].to_f
    }
  end

  
private

  def load_user_name
    self.name = "#{self.first_name} #{self.last_name}"
    self.last_name = self.last_name.capitalize
    self.first_name = self.first_name.capitalize
  end

  def reprocess_avatar
    avatar.reprocess!
  end

  def gravatar_id
    Digest::MD5.hexdigest(self.email.downcase) if self.email
  end

  def apply_trusted_services(omniauth)

    # Merge user_info && extra.user_info
    user_info = omniauth['info']
    if omniauth['extra'] && omniauth['extra']['user_hash']
      user_info.merge!(omniauth['extra']['user_hash'])
    end

    # try name or nickname
    if self.name.blank?
      self.name   = user_info['name']   unless user_info['name'].blank?
      self.name ||= user_info['nickname'] unless user_info['nickname'].blank?
      self.name ||= (user_info['first_name']+" "+user_info['last_name']) unless \
        user_info['first_name'].blank? || user_info['last_name'].blank?
    end

    if self.email.blank?
      self.email = user_info['email'] unless user_info['email'].blank?
    end

    # Set a random password for omniauthenticated users
    self.password, self.password_confirmation = String::random_string(20)
    self.confirmed_at, self.confirmation_sent_at = Time.now

    # Build a new Authentication and remember until :after_create -> save_new_authentication
    @new_auth = authentications.build( :uid => omniauth['uid'], :provider => omniauth['provider'])
  end

  # Called :after_create
  def save_new_authentication
    @new_auth.save unless @new_auth.nil?
  end

  # Inform admin about sign ups and cancellations of accounts
  def async_notify_on_creation
     DelayedJob.enqueue('NewSignUpNotifier', Time.now, self.id)
  end

  # Inform admin about cancellations of accounts
  def async_notify_on_cancellation
     DelayedJob.enqueue('CancelAccountNotifier', Time.now, self.inspect)
  end

  # Inform admin if someone confirms an account
  def notify_if_confirmed
    if attribute_changed?('confirmed_at')
      DelayedJob.enqueue('AccountConfirmedNotifier', Time.now, self.id)
    end
  end

  # If created user is first user, confirm and make admin
  def first_user_hook
    if User.count < 2
      self.confirmed_at = Time.now
      self.role=:admin
      self.save!
    end
  end

end

