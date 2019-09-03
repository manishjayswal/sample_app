require 'rails_helper'

RSpec. describe MicropostsController, type: :controller do
    #normal user
    let(:user) { create(:user)}
    let(:other_user) { create(:user)}

    #sample micropost attributes
    let(:sample_post_attributes) do
        {
            params: { micropost: { content: 'Lorem ipsum dolor it'} }
        }
    end
    let(:micropost) { create(:micropost, user: user)}

    #sample micropost
    let(:sample_post) {{ params: { micropost: micropost } } } 

    describe 'POST #create' do
        context "non logged in user posts" do
            it "should not create the post" do
                expect{
                        post :create, sample_post_attributes
                }.not_to change(Micropost, :count)
            end
        end

        context "logged in user posts" do
            it "should create the post" do
                session[:user_id] = user.id 
                expect {
                    post :create, sample_post_attributes
                }.to change(Micropost, :count).by(1)
            end
            it "should redirect to root url" do
                session[:user_id] = user.id
                post :create, sample_post_attributes
                expect(response).to redirect_to(root_url)
            end
        end
    end
    describe 'DELETE #destroy' do
        context "non logged in user" do
            it "should not change the number of micropost" do
                micropost
                expect{
                    delete :destroy, params: {id: micropost.id }
                }.not_to change(Micropost, :count)
            end
        end
        context "logged in user others microposts" do
            it "should not delete micropost" do
                micropost
                expect{
                    delete :destroy, params: {id: micropost.id},
                    session: {user_id: other_user.id}
                }.not_to change(Micropost, :count)
            end
        end
        context "logged in admin" do
            it "should decrease the micropost by 1" do
                micropost
                expect {
                    delete :destroy, params: {id: micropost.id},
                    session: {user_id: user.id}
                }.to change(Micropost, :count).by(-1)
             end
        end
    end
end


