$(document).ready(function() {
  const urlParams = new URLSearchParams(window.location.search);
  const columns = urlParams.get('columns');
  if (columns == 'week') {
    $('th.period').each(function() {
      const week = $(this).text();
      const momentObject = moment(week, 'YYYY-WW');
      const start = momentObject.startOf('isoweek').format('DD/MM/YYYY');
      const end = momentObject.endOf('isoweek').format('DD/MM/YYYY');
      $(this).attr('title', start + ' - ' + end);
    });
  }
});