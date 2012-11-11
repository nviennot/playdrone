jQuery ->
  form = $('form.search')

  submit_timer = null
  query = null
  last_params = null
  last_query = null

  perform_query = (params) ->
    return if params == last_params
    query.abort if query
    query = $.ajax
      url: '/search',
      data: params,
      success: (results) ->
        $('#results').html(results)
        last_params = params
      error: ->
        $('#results').html("<div class='span12'><p>Error executing query</p></div>")
      complete: ->
        query = null

  eventually_submit = ->
    clearInterval(submit_timer) if submit_timer
    submit_timer = setInterval((-> form.trigger('submit')), 100)

  form.find('#query').keyup ->
    query = this.value
    if query != last_query
      last_query = query
      pattern = "lines:*#{query.replace(new RegExp("[^\\w]","g"),"*")}*" if query.length > 0
      filter = query.replace(new RegExp("[^\\w]","g"),".") if query.length > 0
      form.find('#pattern').val(pattern)
      form.find('#filter').val(filter)
      eventually_submit()

  form.find('#pattern, #filter').keyup ->
    eventually_submit()

  form.find('#per_page').change ->
    eventually_submit()

  form.find('#refresh').click ->
    last_params = null
    eventually_submit()

  form.submit ->
    clearInterval(submit_timer) if submit_timer
    submit_timer = null

    if form.find('#pattern').val()
      perform_query(form.serialize())
    else
      $('#results').text('')
    false

  $('.source-paginate a').live 'click', ->
    perform_query(this.href.split("?")[1])
    false
