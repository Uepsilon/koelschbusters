require 'spec_helper'

describe "news/edit" do
  before(:each) do
    @news = assign(:news, stub_model(News,
      :title => "MyString",
      :slug => "MyString",
      :body => "MyText",
      :teaser => "MyText",
      :user_id => 1
    ))
  end

  it "renders the edit news form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", news_path(@news), "news" do
      assert_select "input#news_title[name=?]", "news[title]"
      assert_select "input#news_slug[name=?]", "news[slug]"
      assert_select "textarea#news_body[name=?]", "news[body]"
      assert_select "textarea#news_teaser[name=?]", "news[teaser]"
    end
  end
end
