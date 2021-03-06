require 'rails_helper'
def check_valid_or_invalid_file_with_3_columns(it_condition_string, file_path_string, have_content_string1, have_content_string2)
  it it_condition_string do
    login_as("instructor6")
    visit '/assignments/1/edit'
    click_link "Topics"
    click_link "Import topics"
    file_path = Rails.root + file_path_string
    attach_file('file', file_path)
    click_button "Import"
    click_link "Topics"
    expect(page).to have_content(have_content_string1)
    expect(page).to have_content(have_content_string2)
  end
end
  
describe "Integration tests for instructor interface" do
  integration_test_instructor_interface
  instructor_login  
  
 

  
  describe "Create a course", type: :controller do
    it "is able to create a public course or a private course" do
      login_as("instructor6")
      visit '/course/new?private=0'
      fill_in "Course Name", with: 'public course for test'
      click_button "Create"
      expect(Course.where(name: "public course for test")).to exist

      visit '/course/new?private=1'
      fill_in "Course Name", with: 'private course for test'
      click_button "Create"
      expect(Course.where(name: "private course for test")).to exist
    end
  end

  describe "View Publishing Rights" do
    it 'should display teams for assignment without topic' do
      login_as("instructor6")
      visit '/participants/view_publishing_rights?id=1'
      expect(page).to have_content('Team name')
      expect(page).not_to have_content('Topic name(s)')
      expect(page).not_to have_content('Topic #')
    end
  end
 
  describe "Import tests for assignment topics" do
    it_condition_string = 'should be valid file with 3 columns'
    file_path_string = "spec/features/assignment_topic_csvs/3-col-valid_topics_import.csv"
    have_content_string1 = 'expertiza'
    have_content_string2 = 'mozilla'
    check_valid_or_invalid_file_with_3_columns(it_condition_string, file_path_string, have_content_string1, have_content_string2)
    it_condition_string = 'should be a valid file with 3 or more columns'
    file_path_string = "spec/features/assignment_topic_csvs/3or4-col-valid_topics_import.csv"
    have_content_string1 = 'capybara'
    have_content_string2 = 'cucumber'
    check_valid_or_invalid_file_with_3_columns(it_condition_string, file_path_string, have_content_string1, have_content_string2)
    it 'should be a invalid csv file' do
      login_as("instructor6")
      visit '/assignments/1/edit'
      click_link "Topics"
      click_link "Import topics"
      file_path = Rails.root + "spec/features/assignment_topic_csvs/invalid_topics_import.csv"
      attach_file('file', file_path)
      click_button "Import"
      click_link "Topics"
      expect(page).not_to have_content('airtable')
      expect(page).not_to have_content('devise')
    end
    
    it 'should be an random text file' do
      login_as("instructor6")
      visit '/assignments/1/edit'
      click_link "Topics"
      click_link "Import topics"
      file_path = Rails.root + "spec/features/assignment_topic_csvs/random.txt"
      attach_file('file', file_path)
      click_button "Import"
      click_link "Topics"
      expect(page).not_to have_content('this is a random file which should fail')
    end
  end

  describe "View assignment scores" do
    it 'is able to view scores' do
      login_as("instructor6")
      visit '/grades/view?id=1'
      expect(page).to have_content('Summary report')
    end
  end
end
