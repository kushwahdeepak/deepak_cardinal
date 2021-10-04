$(document).ready(function(){
  const items = document.querySelectorAll(".accordion a");

  items.forEach(item => item.addEventListener('click', toggleAccordion));
});
