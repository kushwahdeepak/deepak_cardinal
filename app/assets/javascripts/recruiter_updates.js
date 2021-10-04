//= require abracadabra

$(document).ready(function(){
  $.abracadabra();
  $('#check_all').on("click", function() {
    // grouping all the checkbox using the classname
    var checkboxes = $('input[type="checkbox"]');
    // check whether checkboxes are selected.
    if(checkboxes.prop("checked")){
      // if they are selected, unchecking all the checkbox
      checkboxes.prop("checked",false);
      } else {
      // if they are not selected, checking all the checkbox
      checkboxes.prop("checked",true);
    }
  });
});
