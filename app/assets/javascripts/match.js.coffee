$(->
  $('.match_cat').click(->
    app = $(this).attr('app')
    cat = $(this).text()
    $.post("/matches/#{app}", category: cat, (data) =>
      if data == 'true'
        $(this).addClass('selected')
      else
        $(this).removeClass('selected')
    )

    return false
  )
)
