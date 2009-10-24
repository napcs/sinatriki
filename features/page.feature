Feature: creating a new page in the wiki
As an average anonymous user
I want to create a page about Ruby
So that I can tell everyone how awesome it is.

Scenario: Creating a new page and editing its content
Given I go to "/ruby"
 Then I should see "Edit this page"
 When I click "Edit this page" 
 And I fill in "body" with "Ruby is the best programming language in the whole world!"
 And I press "Save"
 Then I should see "Ruby is the best programming language in the whole world!"