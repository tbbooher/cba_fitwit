Feature: Home
  In order show up stuff on the root page
  As an user
  I want see some elements


  Background:
    Given the following user records
      | email            | name      | roles_mask | password         | password_confirmation | confirmed_at         |
      | admin@iboard.cc  | admin     | 31         | thisisnotsecret  | thisisnotsecret       | 2010-01-01 00:00:00  |
    And the following page records
      | title          | body                 | show_in_menu |
      | A Twitter page | Lorem Twittum        | true         |

  Scenario: Link Show drafts should be displayed if draft mode is off
     Given I am logged in as user "admin@iboard.cc" with password "thisisnotsecret"
     And I am on the home page
     And draft mode is off
     Then I should see "Show drafts"
     
  Scenario: Link Hide drafts should be displayed if draft mode is on
     Given I am logged in as user "admin@iboard.cc" with password "thisisnotsecret"
     And I am on the home page
     And draft mode is on
     Then I should see "Hide drafts"     
     
  Scenario: Get empty RSS-Feed
    Given I am on the rss feed
    Then I should see "TESTFEED"
    And I should see "A Twitter page"
    And I should see "Lorem Twittum"
    
  Scenario: BUGFIX: do not concat to view for builder
    Given the following blogs with pages
      | title    | page_name | page_body                  | is_draft |
      | PageBlog | PageOne   | A wonderful body           | false    |
      | PageBlog | PageTwo   | This page should be there  | false    |
    And the following posting records for blog "PageBlog" and user "admin"
      | title         | body                                  | is_draft |
      | Posting one   | lorem ipsum with <p>some<br></p> html | false    |
      | Posting Draft | A Posting Draft | true     |
    And I am on the rss feed
    Then I should see a valid rss-feed containing "&lt;p&gt;lorem ipsum with some html&lt;p&gt;"
    
  Scenario: RSS-Feed should not show drafts
    Given the following blogs with pages
      | title    | page_name | page_body                      | is_draft |
      | PageBlog | PageOne   | A wonderful body               | false    |
      | PageBlog | PageTwo   | This page should not be there  | true    |
    And the following posting records for blog "PageBlog" and user "admin"
      | title         | body                                  | is_draft |
      | Posting one   | Should be shown                       | false    |
      | Posting Draft | A Posting Draft                       | true     |
    And I am on the rss feed
    Then I should not see "This page should not be there"
    And I should not see "A Posting Draft"
    And I should see "Should be shown"
    And I should see "A wonderful body"
