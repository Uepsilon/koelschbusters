class PagesController < ApplicationController

  def carnival_float
    @stories = YAML.load_file(Rails.root.join('config', 'carnival_floats.yml'));
    @stories = @stories['carnival_floats']
  end
end
