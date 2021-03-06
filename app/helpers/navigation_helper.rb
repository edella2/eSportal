module NavigationHelper
  def current_page_is_tournament?
    current_page?('/') || current_page?('/tournaments')
  end

  def display_welcome?
    request.original_fullpath == "/"
  end

  def current_page_is_calendar?
    current_page?('/calendar')
  end
end
