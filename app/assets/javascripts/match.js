/*$(document).ready(function() {

  $('.star').on('click', function() {
    $(this).toggleClass('star-checked');
  });
  $('.ckbox label').on('click', function() {
    $(this).parents('tr').toggleClass('selected');
  });
  $('.btn-filter').on('click', function() {
    var $target;
    $target = $(this).data('target');
    if ($target !== 'all') {
      $('.table tr').css('display', 'none');
      $('.table tr[data-status="' + $target + '"]').fadeIn('slow');
    } else {
      $('.table tr').css('display', 'none').fadeIn('slow');
    }
  });
});
*/
// ---
// generated by coffee-script 1.9.2

  function myFunction() {
    document.getElementById("prfcBut").style.backgroundColor='#990000'
    var button=document.getElementById("prfcBut");
    var $target;
    $target = $(button).data('target');
    window.alert($target);
    $('.table tr[data-status="' + $target + '"]').hide();
    

  }

