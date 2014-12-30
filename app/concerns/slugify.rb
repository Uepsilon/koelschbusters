# encoding: UTF-8
module Slugify
  def self.slugify(unslugged)
    slug = unslugged.to_s
    slug.gsub!(/%/, ' prozent')
    slug.gsub!(/€/, ' euro')
    slug.parameterize
  end
end
