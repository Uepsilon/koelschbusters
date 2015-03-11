# == Schema Information
#
# Table name: events
#
#  id          :integer          not null, primary key
#  internal    :boolean
#  title       :string(255)
#  description :text
#  starts_at   :datetime
#  ends_at     :datetime
#  location    :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Event < ActiveRecord::Base
end
