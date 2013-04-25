shared_examples_for "has insufficient rights" do
  it { response.status.should eq(401) }
end

shared_examples_for "has to be logged in" do
  it { should redirect_to(:new_user_session) }
end