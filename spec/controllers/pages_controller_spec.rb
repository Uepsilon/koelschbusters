require 'spec_helper'

describe PagesController do
  render_views

  describe 'GET imprint' do
    before(:each) { get :imprint }

    it { should render_template(:imprint) }
    it { response.body.should include(Rails.application.secrets.president_name) }
    it { response.body.should include(ApplicationHelper.email_antispam Rails.application.secrets.president_email) }
    it { response.body.should include(Rails.application.secrets.admin_name) }
    it { response.body.should include(ApplicationHelper.email_antispam Rails.application.secrets.admin_email) }
    it { response.body.should include(Rails.application.secrets.contact_street) }
    it { response.body.should include(Rails.application.secrets.contact_city) }
  end
end
