// inject "Clone" link into "Subtask" table
jQuery(function(){
  // extract current issue ID from URL (easiest)
  var matches = location.pathname.match(/^\/issues\/(\d+)/);

  if (matches) {
    var issueId = matches[1];

    // find the existing "Add" link
    var addLink = jQuery('#issue_tree .contextual a:contains("Add")');
    // use it to create an almost identical "Clone" link
    addLink.clone()
      .text("Clone")
      .attr('href', addLink.attr('href') + "&copy_from=" + issueId)
      .appendTo(addLink.parent());
  }
});
