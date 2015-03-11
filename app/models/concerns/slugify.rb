module Slugify
  extend ActiveSupport::Concern

  def slugify
    slug = title.to_s
    slug.gsub!(/%/, ' prozent')
    slug.gsub!(/€/, ' euro')
    slug.parameterize
  end
end
