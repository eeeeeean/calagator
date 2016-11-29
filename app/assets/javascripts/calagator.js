//= require jquery
//= require jquery_ujs
//= require jquery-ui/effect
//= require calagator/forms
//= require calagator/mapping
//= require leaflet.awesome-markers
//= require mustache
//= require jquery-ui/selectmenu

// Shows hidden section when a link is clicked, and hides the link.
//
// The link must have a DOM id that corresponds to the section to display,
// e.g. a "foo_toggle" link relates to the "foo" section.
$(document).on('click','.expander_toggle', function(event) {
  var id_to_hide = event.target.id;
  var id_to_show = id_to_hide.replace(/_toggle$/, "");
  $("#"+id_to_hide).hide(200);
  $("#"+id_to_show).show(200);
  $e = event;
});

$(document).ready(function(){
  $('.select-tag').selectmenu( {
   width: 250 } );

  $('.select-tag').on('selectmenuchange', function() {
    console.log('changed');
    window.location.href= location.href.split('?')[0] + '?region=' + this[this.selectedIndex].text
  });
});


