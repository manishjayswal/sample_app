require 'rails_helper'

RSpec.feature "UserMicroposts", type: :feature do
    let(:user) { create(:user)}
    let(:micropost) { create(:micropost, user: user) }
    let(:valid_params) { build(:micropost, user: user).attributes }

    before do
        login(user, 'gaggag')
        visit '/'
        fill_in 'micropost_content', with: params[:content]
        attact_relevant_file if respond_to? :attact_relevant_file
        click_button 'Post'
    end

    context "post with invalid content" do
        context "post with empty content" do
            let(:params) { valid_params.merge("content"=> '')}
            scenario "sees the error messages" do
                expect(page).to have_content("Content can't be blank")
            end
        end

        let(:params) { valid_params }
        context "post with invalid file format" do
            let(:attact_relevant_file) do
                attach_file 'micropost_picture' Rails.root + 'spec/fixtures/languages.csv'
            end
            scenario "sees the error message" do
                expect(page).to have_content("Picture You are not allowed to upload \"csv\"")
            end
        end

        context "post with large file" do
            let(:attact_relevant_file) do
                attach_file 'micropost_picture', Rails.root + 'spec/fixtures/invalid.png'
            end
            scenario "sees the error message" do
                expect(page).to have_content("Picture can't be greater than 300 kilobytes")
            end
        end
    end
end