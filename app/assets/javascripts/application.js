// This is where you should bootstrap your JS app
//= require jquery_init.js
//= require popper
//= require bootstrap
//= require select2
//= require_tree .

var mouseover_search;
mouseover_search = function() {

  $(".unmoused-search").show();
  $(".moused-search").hide();

  $(".unmoused-search").mouseenter(function() {
      $(".moused-search").show();
      $(".unmoused-search").hide();
      $(this).hide();
  });

  $(".moused-search").mouseout(function() {
    $(".unmoused-search").show();
    $(".moused-search").hide();
    $(this).hide();
  });
};

$(document).ready(mouseover_search);

function toggleAccordion(){
  this.classList.toggle('active');
  this.nextElementSibling.classList.toggle('active');
}
