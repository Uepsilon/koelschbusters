require 'spec_helper'

describe EventDecorator do
  let!(:event) { create(:event).decorate }
  let!(:event_without_end_date) { create(:event, ends_at: nil).decorate }

  it { expect(event.start_date).to eq I18n.l(event.starts_at, format: :short) }
  it { expect(event.end_date).to_not be_blank }
  it { expect(event.end_date).to eq I18n.l(event.ends_at, format: :short) }

  it { expect(event_without_end_date.start_date).to eq I18n.l(event_without_end_date.starts_at, format: :short) }
  it { expect(event_without_end_date.end_date).to be_blank }
end
