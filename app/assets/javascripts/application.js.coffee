$ ->
  $('html').keyup (e) ->
    code = e.which
    if e.shiftKey == true && code == 191
        $("#dialog-help").dialog();
    else if code == 74
      console.log 'next'
    else if code == 75
      console.log 'prev'
    else
      console.log code
     
