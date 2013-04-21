shared_examples_for "insufficient accessrights" do 
  it { response.response_code.should eq(401) }
end