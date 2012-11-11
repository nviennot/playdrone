jQuery ->
  form = $('form.search')
  form.find('#query').keyup ->
    query = this.value
    if query != last_query
      last_query = query
      pattern = "lines:#{query.replace(new RegExp("[^\\w]","g"),"*")}" if query.length > 0
      filter = query.replace(new RegExp("[^\\w]","g"),".") if query.length > 0
      form.find('#pattern').val(pattern)
      form.find('#filter').val(filter)
