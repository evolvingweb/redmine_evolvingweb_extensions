$(document).ready(function() {
  const urlParams = new URLSearchParams(window.location.search);
  const criteria = urlParams.getAll('criteria[]');

  if ($('#columns option:selected').val() == 'week') {
    $('th.period').each(function() {
      const week = $(this).text();
      const momentObject = moment(week, 'YYYY-WW');
      const start = momentObject.startOf('isoweek').format('DD/MM/YYYY');
      const end = momentObject.endOf('isoweek').format('DD/MM/YYYY');
      $(this).attr('title', start + ' - ' + end);
    });
  }

  if (criteria.length) {
    if ($('#time-report th')[criteria.length - 1]) {
      for (criteria_index = 0; criteria_index < criteria.length; criteria_index++) {
        var criteria_text = $('#time-report th')[criteria_index].innerText;
        var replace_text = 'criteria%5B%5D=' + criteria[criteria_index];
        var url = window.location.href.replace(replace_text, '');
        var link = '<a href="' + url + '" class="criteria-remove-link"><span class="icon-only icon-close">Remove</span> ' + criteria_text + '</a>';
        $('#query_form > p').append(link);
      }
    }
  }
  else {
    var project_url_name = window.location.pathname.split('/')[2];
    setTimeout(function() {
      if ($('input[type=hidden][name=project_id]').length) {
        var project_id = $('input[type=hidden][name=project_id]').val();
        $('select[name="v[project_id][]"] option').each(function() {
          if ($(this).val() == project_id) {
            $(this).attr('selected', 'selected');
            $('#query_form').submit();
            return;
          }
        });
      }
    }, 100);
  }

});