jQuery ->
  if $('#infinite-scrolling').size() > 0
    test = $('#infinite-scrolling').size()

    $(window).on 'scroll', ->
      more_tournaments_url = $('.pagination .next_page a').attr('href')
      console.log(more_tournaments_url)

      if more_tournaments_url && $(window).scrollTop() > $(document).height() - $(window).height() - 60
        $('.pagination').html('<img src="/assets/ajax-loader.gif" alt="Loading..." title="Loading..." />')
        $.getScript more_tournaments_url
        return
      return