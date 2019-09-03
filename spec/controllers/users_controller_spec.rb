require 'rails_helper'

RSpec.describe UsersController, type: :controller do

    #these are users with admin privilege
    let(:super_user) { create(:user, :super) }

    let(:another_super_user) { create(:user, :super)}

    #for user without admin privilege
    let(:rahul) { create(:user)}

    #valid session for rahul
    let(:valid_session) { { user_id: rahul.id} }

    #valid admin session
    let(:admin_session) { { user_id: super_user.id}}

    #valid user parameters
    let(:valid_params) do
        {
            user: {
                name: 'manish',
                email: 'manish1@gmail.com',
                password: 'manish1',
                password_confirmation: 'manish1'
            }
        }
    end 
    #invalid user parameters
    let(:invalid_params) { { user: build(:user, email: '').attributes }}

    describe "GET #new" do
        it "should get new" do
            get :new
            expect(response).to be_successful
        end
    end

    describe "GET #index" do
        it "should redirect index when not logged in" do
            get :index
            expect(response).not_to be_successful
       end
       it "should allow logged in user to access" do
            get :index, session: valid_session
            expect(response).to be_successful
        end
    end

    describe "GET #edit" do
        it "returns success for logged in user" do
            get :edit, params: {id: rahul.id}, session: valid_session
            expect(response).to be_successful
        end
        it "should redirect edit when not logged in user" do
            get :edit, params: {id: rahul.id}
            expect(response).not_to be_successful
        end
    end

    describe "PUT #update" do
        it "redirects update when user is not logged in" do
            put :update, params: { id: rahul.id,
                                    user: { name: 'manish',
                                            email: 'm@gmail.com'} 
                                        }
            expect(response).to redirect_to(login_url)
        end

    end

    describe "DELETE #destroy" do
        it "should redirect destroy when user is not logged in"do
            put :destroy, params: { id: rahul.id,
                                    user: { name: 'manish', 
                                            email: 'm@gmail.com'}} 
            expect(response).to redirect_to(login_url)
        end

        it "should not allow to delete when logged in user is not admin" do
            rahul
            expect { delete :destroy, params: { id: rahul.id }, 
                    session: valid_session
            }.not_to change(User, :count)

        end
    end

    describe "follow pages" do
        describe "when not signed in"do
            it "should protect 'following'" do
                get :following, :id =>1
                response.should redirect_to(signin_path)
            end
            it "should protect 'followers'" do
                get :followers, :id => 1
                response.should redirect_to(signin_path)
            end
        end
        describe "when signed in" do
            before(:each) do
                @user = test_sign_in(Factory(:user))
                @other_user = Factory(:user, :email => Factory.next(:email) )
                @user.follow! (@other_user)
            end
            it "should show user following" do
                get :following, :id => @user 
                response.should have_selector("a", :href => user_path(@other_user), 
                                                    :content => @other_user.name)
            end
            it "should show user followers" do
                get :followers, :id => @other_user
                response.should have_selector("a", :href => user_path(@user), 
                                                    :content => @user.name)
            end
        end
    end
end
