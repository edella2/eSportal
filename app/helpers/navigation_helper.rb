module NavigationHelper

  def current_page_is_home?
    current_page?('/') || current_page?('/tournaments')
  end

end
