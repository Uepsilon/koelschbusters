require 'spec_helper'

describe PagesController do
  render_views

  describe 'GET imprint' do
    before(:each) { get :imprint }

    it { should render_template(:imprint) }
    it { response.body.should include(Figaro.env.president_name) }
    it { response.body.should include(ApplicationHelper.email_antispam Figaro.env.president_email) }
    it { response.body.should include(Figaro.env.admin_name) }
    it { response.body.should include(ApplicationHelper.email_antispam Figaro.env.admin_email) }
    it { response.body.should include(Figaro.env.contact_street) }
    it { response.body.should include(Figaro.env.contact_city) }
  end
end
