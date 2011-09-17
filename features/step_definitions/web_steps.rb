# -*- encoding : utf-8 -*-

# IMPORTANT: This file is generated by cucumber-rails - edit at your own peril.
# It is recommended to regenerate this file in the future when you upgrade to a
# newer version of cucumber-rails. Consider adding your own code to a new file
# instead of editing this one. Cucumber will automatically load all features/**/*.rb
# files.


require 'uri'
require 'cgi'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

module WithinHelpers
  def with_scope(locator)
    locator ? within(locator) { yield } : yield
  end
end
World(WithinHelpers)

Given /^(?:|I )am on (.+)$/ do |page_name|
  visit path_to(page_name)
end

When /^(?:|I )go to (.+)$/ do |page_name|
  visit path_to(page_name)
end

When /^(?:|I )press "([^"]*)"(?: within "([^"]*)")?$/ do |button, selector|
  with_scope(selector) do
    click_button(button)
  end
end

When /^(?:|I )follow "([^"]*)"(?: within "([^"]*)")?$/ do |link, selector|
  with_scope(selector) do
    click_link(link.to_s)
  end
end

When /^(?:|I )fill in "([^"]*)" with "([^"]*)"(?: within "([^"]*)")?$/ do |field, value, selector|
  with_scope(selector) do
    fill_in(field, :with => value)
  end
end

When /^(?:|I )fill in "([^"]*)" for "([^"]*)"(?: within "([^"]*)")?$/ do |value, field, selector|
  with_scope(selector) do
    fill_in(field, :with => value)
  end
end

# Use this to fill in an entire form with data from a table. Example:
#
#   When I fill in the following:
#     | Account Number | 5002       |
#     | Expiry date    | 2009-11-01 |
#     | Note           | Nice guy   |
#     | Wants Email?   |            |
#
# TODO: Add support for checkbox, select og option
# based on naming conventions.
#
When /^(?:|I )fill in the following(?: within "([^"]*)")?:$/ do |selector, fields|
  with_scope(selector) do
    fields.rows_hash.each do |name, value|
      When %{I fill in "#{name}" with "#{value}"}
    end
  end
end

When /^(?:|I )select "([^"]*)" from "([^"]*)"(?: within "([^"]*)")?$/ do |value, field, selector|
  with_scope(selector) do
    select(value, :from => field)
  end
end

When /^(?:|I )check "([^"]*)"(?: within "([^"]*)")?$/ do |field, selector|
  with_scope(selector) do
    check(field)
  end
end

When /^(?:|I )uncheck "([^"]*)"(?: within "([^"]*)")?$/ do |field, selector|
  with_scope(selector) do
    uncheck(field)
  end
end

When /^(?:|I )choose "([^"]*)"(?: within "([^"]*)")?$/ do |field, selector|
  with_scope(selector) do
    choose(field)
  end
end

When /^(?:|I )attach the file "([^"]*)" to "([^"]*)"(?: within "([^"]*)")?$/ do |path, field, selector|
  with_scope(selector) do
    attach_file(field, path)
  end
end

Then /^(?:|I )should see JSON:$/ do |expected_json|
  require 'json'
  expected = JSON.pretty_generate(JSON.parse(expected_json))
  actual   = JSON.pretty_generate(JSON.parse(response.body))
  expected.should == actual
end

Then /^(?:|I )should see "([^"]*)"(?: within "([^"]*)")?$/ do |text, selector|
  with_scope(selector) do
    if page.respond_to? :should
      page.should have_content(text)
    else
      assert page.has_content?(text)
    end
  end
end

Then /^(?:|I )should see \/([^\/]*)\/(?: within "([^"]*)")?$/ do |regexp, selector|
  regexp = Regexp.new(regexp)
  with_scope(selector) do
    if page.respond_to? :should
      page.should have_xpath('//*', :text => regexp)
    else
      assert page.has_xpath?('//*', :text => regexp)
    end
  end
end

Then /^(?:|I )should not see "([^"]*)"(?: within "([^"]*)")?$/ do |text, selector|
  with_scope(selector) do
    if page.respond_to? :should
      page.should have_no_content(text)
    else
      assert page.has_no_content?(text)
    end
  end
end

Then /^(?:|I )should not see \/([^\/]*)\/(?: within "([^"]*)")?$/ do |regexp, selector|
  regexp = Regexp.new(regexp)
  with_scope(selector) do
    if page.respond_to? :should
      page.should have_no_xpath('//*', :text => regexp)
    else
      assert page.has_no_xpath?('//*', :text => regexp)
    end
  end
end



Then /^the "([^"]*)" field(?: within "([^"]*)")? should contain "([^"]*)"$/ do |field, selector, value|
  with_scope(selector) do
    field = find_field(field)
    field_value = (field.tag_name == 'textarea') ? field.text : field.value
    if field_value.respond_to? :should
      field_value.should =~ /#{value}/
    else
      assert_match(/#{value}/, field_value)
    end
  end
end

Then /^the "([^"]*)" field(?: within "([^"]*)")? should not contain "([^"]*)"$/ do |field, selector, value|
  with_scope(selector) do
    field = find_field(field)
    field_value = (field.tag_name == 'textarea') ? field.text : field.value
    if field_value.respond_to? :should_not
      field_value.should_not =~ /#{value}/
    else
      assert_no_match(/#{value}/, field_value)
    end
  end
end

Then /^the "([^"]*)" checkbox(?: within "([^"]*)")? should be checked$/ do |label, selector|
  with_scope(selector) do
    field_checked = find_field(label)['checked']
    if field_checked.respond_to? :should
      field_checked.should be_true
    else
      assert field_checked
    end
  end
end

Then /^the "([^"]*)" checkbox(?: within "([^"]*)")? should not be checked$/ do |label, selector|
  with_scope(selector) do
    field_checked = find_field(label)['checked']
    if field_checked.respond_to? :should
      field_checked.should be_false
    else
      assert !field_checked
    end
  end
end

Given /^the following site_menu$/ do |table|
  SiteMenu.unscoped.delete_all
  table.hashes.each do |hash|

    level = hash[:name]
    target= hash[:target]
    levels = level.split(/\./)

    search_in = SiteMenu
    for name in levels
      item = search_in.where(:name => name).first
      if item
        search_in = item.children
      else
        search_in.create(name: name, target:target)
      end
    end
  end
end

Then /^(?:|I )should be on (.+)$/ do |page_name|
  current_path = URI.parse(current_url).path
  if current_path.respond_to? :should
    current_path.should == path_to(page_name)
  else
    assert_equal path_to(page_name), current_path
  end
end

Then /^(?:|I )should have the following query string:$/ do |expected_pairs|
  query = URI.parse(current_url).query
  actual_params = query ? CGI.parse(query) : {}
  expected_params = {}
  expected_pairs.rows_hash.each_pair{|k,v| expected_params[k] = v.split(',')}

  if actual_params.respond_to? :should
    actual_params.should == expected_params
  else
    assert_equal expected_params, actual_params
  end
end

Then /^show me the page$/ do
  save_and_open_page
end


Then /^I should not see class (.+)$/ do |classname|
  assert !page.has_content?('class="'+classname+"'")
end


Given /^the following default pages?$/ do |table|
  Page.unscoped.delete_all
  t = PageTemplate.find_or_create_by(name: 'default')
  t.save!
  table.hashes.each do |hash|
    Factory('page', hash.merge( :page_template_id => t.id ))
  end
end

Given /^the following (.+) records?$/ do |factory, table|
  eval "#{factory.camelize}.unscoped.delete_all"
  table.hashes.each do |hash|
    Factory(factory, hash)
  end
end


Given /^only the following page records$/ do |table|
  Page.unscoped.delete_all
  table.hashes.each do |hash|
    p = Page.new( :title => hash[:title], :body => hash[:body], :show_in_menu => false,
       :is_draft => false, :is_template => false, :page_template_id => nil)
    p.translate!
    p.save!
  end
end

Given /^no site_menu exists/ do
  SiteMenu.unscoped.delete_all
end

Given /the default locale/ do
  #  match 'switch_lcoale/:locale' => "home#set_locale", :as => 'switch_locale'
  visit switch_locale_path(I18n.default_locale.to_s)
end


Given /the default user set/ do
  User.unscoped.delete_all
  [
    #ROLES = [:guest, :confirmed_user, :author, :moderator, :maintainer, :admin]
    #see user.rb model
    #
    #  ATTENTION cba makes the first user an admin!
    #  -> The first user of the following hash must be the admin!
    {
      :email => 'admin@iboard.cc',
      :name  => 'admin',
      :roles_mask => 5,
      :password => 'thisisnotsecret', :password_confirmation => 'thisisnotsecret',
      :confirmed_at => "2010-01-01 00:00:00"
    },
    # Define NON-ADMINS BELOW
    {
      :email => 'user@iboard.cc',
      :name  => 'testmax',
      :roles_mask => 1,
      :password => 'thisisnotsecret', :password_confirmation => 'thisisnotsecret',
      :confirmed_at => "2010-01-01 00:00:00"
    },
    {
      :email => 'author@iboard.cc',
      :name  => 'Author',
      :roles_mask => 2,
      :password => 'thisisnotsecret', :password_confirmation => 'thisisnotsecret',
      :confirmed_at => "2010-01-01 00:00:00"
    },
    {
      :email => 'moderator@iboard.cc',
      :name  => 'Moderator',
      :roles_mask => 3,
      :password => 'thisisnotsecret', :password_confirmation => 'thisisnotsecret',
      :confirmed_at => "2010-01-01 00:00:00"
    },
    {
      :email => 'maintainer@iboard.cc',
      :name  => 'maintainer',
      :roles_mask => 4,
      :password => 'thisisnotsecret', :password_confirmation => 'thisisnotsecret',
      :confirmed_at => "2010-01-01 00:00:00"
    },
    {
      :email => 'staff@iboard.cc',
      :name  => 'staff',
      :roles_mask => 4,
      :password => 'thisisnotsecret', :password_confirmation => 'thisisnotsecret',
      :confirmed_at => "2010-01-01 00:00:00"
    }
  ].each do |hash|
    Factory('user', hash)
  end
end
# Make sure not to overwrite your production files!
# Use Rails.env in your filename eg config/twitter.test.html
# and config/twitter.#{Rails.env}.html in your production code.
Given /^the following files?$/ do |table|
  table.hashes.each do |hash|
    f=File.new( File::join(Rails.root,hash['filename'].strip), "w+")
    f.write(hash['content']+"\n")
    f.close
  end
end

Given /^delete file "([^"]*)"$/ do |filename|
  File.unlink( File::join(Rails.root, filename))
end

Given /^I am logged out$/ do
  visit path_to('sign_out')
end

Given /^I am logged in as user "([^"]*)" with password "([^"]*)"$/ do |email, password|
  visit path_to('sign_out')
  visit path_to('sign_in')
  fill_in('user_email', :with => email)
  fill_in('user_password', :with => password)
  click_button('Sign in')
  page.should have_content("Signed in successfully.")
end

Given /^I visit the new posting page for user "([^"]*)"$/ do |user_id|
  visit "/users/#{user_id}/postings/new"
end

Given /^I visit the new episode page for user "([^"]*)"$/ do |user_id|
  visit "/users/#{user_id}/episodes/new"
end

Given /^I click on "([^"]*)"$/ do |button|
  click_button(button.to_s)
end

Given /^I visit the edit posting page for user "([^"]*)" and posting "([^"]*)"$/ do |user_id, posting_id|
  visit edit_user_posting_path(user_id,posting_id)
end

Given /^I click on link "([^"]*)"$/ do |link|
  click_link(link.to_s)
end

Given /^I click on link "([^"]*)" within "([^"]*)"$/ do |arg1, arg2|
  within( :css, "#{arg2}" ) do
    click_link(arg1.to_s)
  end
end

Given /^I visit the edit episode page for user "([^"]*)" and episode "([^"]*)"$/ do |user_id, episode_id|
  visit edit_user_episode_path(user_id,episode_id)
end

Given /^I visit the episode page for user "([^"]*)" and episode "([^"]*)"$/ do |user_id, episode_id|
  visit user_episode_path(user_id,episode_id)
end

Given /^no (.*) records?$/ do |table_name|
  eval "#{table_name.camelize}.unscoped.delete_all"
end

Given /^I visit "([^"]*)"$/ do |url|
  visit url
end

Then /^I should be redirected to the (.+?) page$/ do |url|
  current_path.should == url
end

Given /^I uncheck "([^"]*)" whithin "([^"]*)"$/ do |arg1, arg2|
  within( :css, "div##{arg2}" ) do
    uncheck(arg1)
  end
end

Given /^I check "([^"]*)" whithin "([^"]*)"$/ do |arg1, arg2|
  within( :css, "div##{arg2}" ) do
    check(arg1)
  end
end

Given /^I sign out$/ do
  visit "/users/sign_out"
end

Given /^the following blogs with pages/ do |table|
  Page.unscoped.delete_all
  t = PageTemplate.find_or_create_by(name: 'default')
  table.hashes.each do |params|
    blog = Blog.find_or_create_by(title: params[:title], is_draft: false)
    page = Page.create(:title => params[:page_name], :body => params[:page_body],
      :show_in_menu => false, :is_draft => params[:is_draft] || false)
    page.template = t
    blog.pages << page
    blog.save
  end
end

Given /^I am reading blog of "([^"]*)"$/ do |arg1|
  blog = Blog.where(:title => arg1).first
  visit "/blogs/#{blog.id.to_s}"
end

Given /^the following comment records for page "([^"]*)"$/ do |commentable, table|
  page = Page.where(:title => commentable).first
  page.comments.unscoped.delete_all
  table.hashes.each do |hash|
    page.comments << Factory('comment', hash)
  end
  page.save
end

Given /^the following posting records for blog "([^"]*)" and user "([^"]*)"$/ do |blog, username, table|
  blog = Blog.unscoped.where(:title => blog).first
  user = User.where(:name => username).first
  blog.postings.unscoped.delete_all
  table.hashes.each do |hash|
    hash[:user_id] = user.id
    blog.postings.create!(hash)
  end
  blog.save!
end

Given /^the following user_notification records for user "([^"]*)"$/ do |username, table|
  user = User.where(:name => username).first
  table.hashes.each do |hash|
    user.user_notifications << UserNotification.new(hash)
  end
  user.save!
end

Given /^the following translated pages/ do |table|
  Page.unscoped.delete_all
  table.hashes.each do |hash|
    p = Page.create( title: hash[:title_en], body: hash[:body_en], is_draft: false )
    p.translate!
    p.t(:de,:title,hash[:title_de])
    p.t(:de,:body, hash[:body_de])
    p.save!
  end
end

Given /^the following translated components for page "([^"]*)"$/ do |page_title, table|
  page = Page.where(title: /#{page_title}/).first
  page.page_components.unscoped.delete_all
  table.hashes.each do |hash|
    c = page.page_components.create( title: hash[:title_en], body: hash[:body_en] )
    c.translate!
    c.t(:de, :title, hash[:title_de])
    c.t(:de, :body, hash[:body_de])
  end
  page.save!
end

Then /^I should be reading "([^"]*)"$/ do |arg1|
  blog = Blog.where( title: arg1).first
  current_path.should == blog_path(blog)
end

Given /^draft mode is off$/ do
  visit draft_mode_path(0)
end

Given /^draft mode is on$/ do
  visit draft_mode_path(1)
end

Given /^I have a clean database$/ do
  Posting.destroy_all
  Page.destroy_all
  Comment.destroy_all
end


Given /^the following components for page "([^"]*)"$/ do |page_title, table|
  page = Page.where(:title => page_title).first
  table.hashes.each do |hash|
    page.page_components.create( :body => hash[:body], :page_template_id =>
      (
      hash[:page_template] ? PageTemplate.where(:name => hash[:page_template]).first.id : nil
      )
    )
  end
  page.save!
end

Then /^I should see a valid rss\-feed containing "([^"]*)"$/ do |arg1|
  assert_match( /http:\/\/www.w3.org\/2005\/Atom/, page.html)
  assert_match( /<content type=\"html\">&lt;p&gt;/, page.html)
end
