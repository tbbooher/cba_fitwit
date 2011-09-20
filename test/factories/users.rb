Factory.define :user do |u|
  u.email 'user@domain.com'
  u.name 'user'
  u.roles_mask 1
  u.password "secret"
  u.first_name "Bob"
  u.last_name "The Builder"
  u.password_confirmation "secret"
end

Factory.define :admin, :class => User do |u|
  u.email 'admin@yourdomain.com'
  u.name 'Administrator'
  u.roles_mask 5
  u.password "secret"
  u.password_confirmation "secret"
  u.first_name "Bob"
  u.last_name "The Builder"
  u.street_address1 "1020 Willoby Lane"
  u.company "Mead"
  u.city "Dayton"
  u.us_state "OH"
  u.zip "45420"
  u.primary_phone "937-544-2828"
end
