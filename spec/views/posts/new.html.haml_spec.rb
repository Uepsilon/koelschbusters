require 'spec_helper'

describe "posts/new" do
  before(:each) do
    assign(:post, stub_model(Post,
      :title => "MyString",
      :slug => "MyString",
      :body => "MyText",
      :teaser => "MyText",
      :author_id => 1
    ).as_new_record)
  end

  it "renders new post form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", posts_path, "post" do
      assert_select "input#post_title[name=?]", "post[title]"
      assert_select "input#post_slug[name=?]", "post[slug]"
      assert_select "textarea#post_body[name=?]", "post[body]"
      assert_select "textarea#post_teaser[name=?]", "post[teaser]"
      assert_select "input#post_author_id[name=?]", "post[author_id]"
    end
  end
end
