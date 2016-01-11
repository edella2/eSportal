module ApplicationHelper

def create_link(text, path)
    class_name = current_page?(path) ? 'active' : ''
    content_tag(:li, class: class_name) do
    link_to text, path
  end
end

end
