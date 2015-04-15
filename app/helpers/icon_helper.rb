module IconHelper
  def icon(icon)
    content_tag(:i, '', class: "glyphicon glyphicon-#{icon}")
  end
end
