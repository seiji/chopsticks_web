$ ->
  content_header_index = 0
  content_headers = $('#content_headers ul li a')  
  content_headers_bt = $("#box").offset().top
  content_headers_ds = 0

  $(document).scroll ->
    content_headers_ds = $(this).scrollTop()
    if content_headers_bt <= content_headers_ds
      $("#box").addClass('follow')
    else if content_headers_bt >= content_headers_ds
      $("#box").removeClass('follow')

  $('html').keydown (e) ->
    code = e.which
    if e.shiftKey == true && code == 191
        $("#dialog-help").dialog();
    else if code == 74
      content_header_index++
      if content_header_index > content_headers.length - 1
        content_header_index = content_headers.length
      content_headers[content_header_index].click()
    else if code == 75
      content_header_index--
      if content_header_index < 0
        content_header_index = 0
      $('#content_headers ul li a')[content_header_index].click()
    else
      console.log code
     
