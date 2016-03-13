require 'spec_helper'

describe PagesController do
  render_views

  describe 'GET imprint' do
    before(:each) { get :imprint }

    it { should render_template(:imprint) }
    it { expect(response.body).to include Rails.application.secrets.president_name }
    it { expect(response.body).to include Rails.application.secrets.president_email.gsub(/@/,'[at]').gsub(/\./, '[dot]') }
    it { expect(response.body).to include Rails.application.secrets.admin_name }
    it { expect(response.body).to include Rails.application.secrets.admin_email.gsub(/@/,'[at]').gsub(/\./, '[dot]') }
    it { expect(response.body).to include Rails.application.secrets.contact_street }
    it { expect(response.body).to include Rails.application.secrets.contact_city }
  end
end
