// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).on("click", ".check_all", function(e) {
  $(".person-contactable").prop("checked", !this.checked);
  $(".person-contactable").click();
});
