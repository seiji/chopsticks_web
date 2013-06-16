$ ->
  $('tr[data-href]').addClass('clickable').click (e) ->
    if (!$(e.target).is('a'))
      window.location = $(e.target).closest('tr').data('href');
    

         
