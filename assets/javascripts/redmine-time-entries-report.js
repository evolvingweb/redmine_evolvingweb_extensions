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
    for (criteria_index = 0; criteria_index < criteria.length; criteria_index++) {
      var criteria_text = $('#time-report th')[criteria_index].innerText;
      var replace_text = 'criteria%5B%5D=' + criteria[criteria_index];
      var url = window.location.href.replace(replace_text, '');
      var link = '<a href="' + url + '" class="criteria-remove-link">Remove ' + criteria_text + '</a>';
      $('#query_form > p').append(link);
    }
  }
  else {
    var project_url_name = window.location.pathname.split('/')[2];
    setTimeout(function() {
      $('select[name="v[project_id][]"] option').each(function() {
        if ($(this).text().toLowerCase().replace(/\s/g, '-') == project_url_name) {
          $(this).attr('selected', 'selected');
          $('#query_form').submit();
        }
      });
    }, 100);
  }

});