// Reset the state of the submit button
$(document).ready(function() {
  
  $('body').on('submit', 'form', function(event){
    $('input[type=submit][data-loading-text]', event.target).button('loading');
  });
  
  $('body').on('reset', 'form', function(event){
    $('input[type=submit][data-loading-text]', event.target).button('reset');
  });
  
});