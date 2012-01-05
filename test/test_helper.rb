require 'simplecov'
SimpleCov.start do
  add_filter "/test/"
end

require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] = "test"
  require File.expand_path('../../config/environment', __FILE__)
  require 'rails/test_help'
  include Devise::TestHelpers
end

Spork.each_run do
  # This code will be run each time you run your specs.
  Dir[File.expand_path(File.join(File.dirname(__FILE__),'..','..',
    'spec','factories','*.rb'))].each { |f| require f }
end



class ActiveSupport::TestCase

  include ActiveMerchant::Billing

  def credit_card_hash(options = {})
    {:number => '4111111111111111',
      :first_name => 'Demosthenes',
      :last_name => 'Booher',
      :month => 8,
      :year => "#{Time.now.year + 1}",
      :verification_value => '123',
      :type => 'visa'    # needs to be an active merchant type
    }.update(options)
    # get the parameters we send the users
  end

  def credit_card(options = {})
    ActiveMerchant::Billing::CreditCard.new( credit_card_hash(options))
  end

  def address(options = {})
    { :first_name => 'Demosthenes',
      :last_name => 'Rex',
      :address1 => '1 Areopagus',
      :address2 => '',
      :city => 'Athens',
      :state => 'FL',
      :country => 'US',
      :zip => '32569',
      :phone => '937-565-2727'
    }.update(options)
  end

  def add_cart_with_items
    @cart = Cart.new
    @cart.add_timeslot(TimeSlot.find(:first).id)
    @request.session[:cart] = @cart
  end

  def login_as(user_label)
    user = Factory.build(user_label.to_sym)
    @request.session[:user_id] = user.id
    return user
  end

  def create_valid_user_with_id(id=nil)
    begin
      unless id.nil?
        user = User.new(
                        :id => id, :email => 'tester@test.te', :name => 'nockenfell',
                        :password => 'secret', :password_confirmation => 'secret'
                       )
      else
        user = User.new(
                        :email => 'tester@test.te', :name => 'nockenfell',
                        :password => 'secret', :password_confirmation => 'secret'
                       )
      end
      user.save!
      user
    rescue
      nil
    end
  end

  def create_valid_user_with_roles_mask(role)
    user = User.new(
                      :email => "#{role.to_s}@test.te", :name => role.to_s,
                      :password => 'secret', :password_confirmation => 'secret'
                   )
    user.role=role
    user.save!
    user
  end

  def create_one_page(title='A Page', body='A Body')
     Page.delete_all
     Page.create title: title, body: body
  end

end
