require 'rails_helper'

RSpec.describe RelationshipsController, type: :controller do
    let(:follower) { create(:user) }
    let(:following) { create(:user) }
    let(:relationship) { create(:relationship, follower: follower, following: following) }
    let(:following_id) { { following_id: following.id} }
    let(:follower_id) { { follower_id: follower.id } }
    let(:follower_session) { { user_id: follower.id } }

    describe 'POST #create' do
            context "when user follows another user without ajax"
                it "should increase relationships" do
                    expect{
                        post :create, params: following_id,
                        session: follower_session
                    }.to change(Relationship, :count).by(1)
                end
                it "should redirect to the follower user" do
                    post :create, params; following_id,
                            session: follower_session
                    expect(response).to redirect_to(following)
                end
            end
            context "when user follows another user with ajax request" do
                it "should increase relationships" do
                    expect{
                        post :create, xhr: true,
                        params: following_id,
                        session: follower_session
                    }.to change(Relationship, :count).by(1)
                end

                it "should render the js template" do
                    post :create, xhr: true,
                    params: following_id,
                    session: follower_session
                    expect(response).to render_template('relationships/create')
                end
            end
    end
        describe 'DELETE #destroy' do
            context "when user unfollows another user without ajax" do
                it "should decrase relationships" do
                    relationship
                    expect{
                        delete :destroy, params: { id: relationship.id},
                        session: follower_session
                    }.to change(Relationship, :count).by(-1)
                end
                it "should redirect to the unfollowed user" do
                    relationship
                    delete :destroy, params: { id: relationship.id},
                    session: follower_session
                    expect(response).to redirect_to(following)
                end
            end

            context "when user unfollows another user with ajax request" do
                it "should decrease relationships" do
                    relationship
                    expect {
                        delete :destroy, xhr: true,
                        params: { id: relationship.id },
                        session: follower_session
                    }.to change(Relationship, :count).by(-1)
                end
                it "should render the js template" do
                    relationship
                    delete :destroy, xhr: true,
                    params: { id: relationship.id },
                    session: follower_session
                    expect(response).to render_template('relationships/destroy')
                end
            end
        end
end
