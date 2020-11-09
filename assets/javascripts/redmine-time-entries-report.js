$(document).ready(function() {
  const urlParams = new URLSearchParams(window.location.search);
  var criteria = urlParams.getAll('criteria[]');
  // If urlParams are not set it's the first load of the page.
  if (criteria.length === 0 && $("input[name='criteria[]']").length) {
    $("input[name='criteria[]']").each(function() {
      criteria.push($(this).val());
    });
    // If it's the first page load, use project_id hidden field.
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

  // Week title attribute.
  if ($('#columns option:selected').val() == 'week') {
    $('th.period').each(function() {
      const week = $(this).text();
      const momentObject = moment(week, 'YYYY-WW');
      const start = momentObject.startOf('isoweek').format('DD/MM/YYYY');
      const end = momentObject.endOf('isoweek').format('DD/MM/YYYY');
      $(this).attr('title', start + ' - ' + end);
    });
  }

  // Reorder columns callback.
  function reorderColumns() {
    var index = 0;
    var newUrl = window.location.href;
    var newCriteria = '';
    $('.criteria-element').each(function() {
      newCriteria += '&criteria%5B%5D=' + $(this).attr('data-criteria');
      newUrl = newUrl.replace(window.originalCriteria[index], '');
      index++;
    });
    if (newCriteria) {
      newUrl += newCriteria;
      // Cleanup url by removing &s left.
      const search = /\&{2,}/gi;
      newUrl = newUrl.replace(search, '&')
      window.location.href = newUrl;
    }
  }

  // Add subproject operator.
  setTimeout(function() {
    if ($("#operators_project_id").length) {
      $("#operators_project_id").append("<option value='=*'>is or subproject</option>");
      if (!urlParams.get('op[project_id]') || urlParams.get('op[project_id]') === '=*') {
        $('#operators_project_id').val('=*');
      }
    }
  }, 100);

  if (criteria.length) {
    if ($('#time-report th')[criteria.length - 1]) {
      var originalCriteria = [];
      $('#query_form > p').append('<ul class="report-columns-handling"></ul>');
      var criteria_text_index = 0;
      for (criteria_index = 0; criteria_index < criteria.length; criteria_index++) {
        if (!criteria[criteria_index]) {
          continue;
        }
        var criteria_text = $('#time-report th')[criteria_text_index].innerText;
        var replace_text = 'criteria%5B%5D=' + criteria[criteria_index];
        var url = window.location.href.replace(replace_text, '');
        if (url === window.location.href) {
          // Encoding was different.
          replace_text = 'criteria[]=' + criteria[criteria_index];
          url = window.location.href.replace(replace_text, '');
        }
        originalCriteria.push(replace_text);
        var link = '<li class="criteria-element" data-criteria="' + criteria[criteria_index] + '"><a href="' + url + '" class="criteria-remove-link"><span class="icon-only icon-close">Remove</span></a>' + criteria_text + '</li>';
        $('#query_form .report-columns-handling').append(link);
        criteria_text_index++;
      }
    }
    window.originalCriteria = originalCriteria;
    $('.report-columns-handling').sortable({
      update: reorderColumns,
      placeholder: "ui-state-highlight"
    });
  }

  /**
   * Make timesheet reports link absolute.
   */
  function makeLinksAbsolute() {
    const urlParams = new URLSearchParams(window.location.search);
    var queryParams = decodeURI(window.location.search);
    var filters = urlParams.getAll('f[]');
    for (filters_index = 0; filters_index < filters.length; filters_index++) {
      switch (filters[filters_index]) {
        case 'project_id':
          var project_id_values = urlParams.getAll('v[project_id][]');
          for (project_id_index = 0; project_id_index < project_id_values.length; project_id_index++) {
            if (project_id_values[project_id_index] === 'mine') {
              queryParams = queryParams.replace('v[project_id][]=mine', '');
              queryParams = queryParams.replace('op[project_id]=%3D', '');
              queryParams = queryParams.replace('f[]=project_id', '');
            }
          }
          break;

        case 'spent_on':
          var spent_on_op = urlParams.get('op[spent_on]');
          var format = 'YYYY-MM-DD';
          switch (spent_on_op) {
            case '>t-':
            case '><t-':
              var days = urlParams.getAll('v[spent_on][]')[0];
              var newOp = '><';
              var todayFormatted = moment().format(format);
              var otherDayFormatted = moment().subtract(days, 'days').format(format);
              var toReplace = 'v[spent_on][]=' + otherDayFormatted + '&v[spent_on][]=' + todayFormatted;
              queryParams = queryParams.replace('v[spent_on][]=' + days, toReplace);
              queryParams = queryParams.replace('op[spent_on]=' + spent_on_op, 'op[spent_on]=' + newOp);
              break;

            case '<t-':
              var days = urlParams.getAll('v[spent_on][]')[0];
              var newOp = '<%3D';
              var otherDayFormatted = moment().subtract(days, 'days').format(format);
              var toReplace = 'v[spent_on][]=' + otherDayFormatted;
              queryParams = queryParams.replace('v[spent_on][]=' + days, toReplace);
              queryParams = queryParams.replace('op[spent_on]=<t-', 'op[spent_on]=' + newOp);
              break;

            case 't-':
              var days = urlParams.getAll('v[spent_on][]')[0];
              var newOp = '%3D';
              var otherDayFormatted = moment().subtract(days, 'days').format(format);
              var toReplace = 'v[spent_on][]=' + otherDayFormatted;
              queryParams = queryParams.replace('v[spent_on][]=' + days, toReplace);
              queryParams = queryParams.replace('op[spent_on]=t-', 'op[spent_on]=' + newOp);
              break;

            case 't':
              var newOp = '%3D';
              var todayFormatted = moment().format(format);
              var toReplace = 'v[spent_on][]=' + todayFormatted;
              queryParams = queryParams.replace('op[spent_on]=t', 'op[spent_on]=' + newOp + "&" + toReplace);
              break;

            case 'ld':
              var newOp = '%3D';
              var otherDayFormatted = moment().subtract(1, 'days').format(format);
              var toReplace = 'v[spent_on][]=' + otherDayFormatted;
              queryParams = queryParams.replace('op[spent_on]=ld', 'op[spent_on]=' + newOp + "&" + toReplace);
              break;

            case 'w':
              var newOp = '><';
              var endDayFormatted = moment().weekday(0).add(6, 'days').format(format);
              var startDayFormatted = moment().weekday(0).format(format)
              var toReplace = 'v[spent_on][]=' + startDayFormatted + '&v[spent_on][]=' + endDayFormatted;
              queryParams = queryParams.replace('op[spent_on]=w', 'op[spent_on]=' + newOp + "&" + toReplace);
              break;

            case 'lw':
              var newOp = '><';
              var endDayFormatted = moment().weekday(0).subtract(1, 'days').format(format);
              var startDayFormatted = moment().weekday(0).subtract(7, 'days').format(format)
              var toReplace = 'v[spent_on][]=' + startDayFormatted + '&v[spent_on][]=' + endDayFormatted;
              queryParams = queryParams.replace('op[spent_on]=lw', 'op[spent_on]=' + newOp + "&" + toReplace);
              break;

            case 'l2w':
              var newOp = '><';
              var endDayFormatted = moment().weekday(0).subtract(1, 'days').format(format);
              var startDayFormatted = moment().weekday(0).subtract(14, 'days').format(format)
              var toReplace = 'v[spent_on][]=' + startDayFormatted + '&v[spent_on][]=' + endDayFormatted;
              queryParams = queryParams.replace('op[spent_on]=l2w', 'op[spent_on]=' + newOp + "&" + toReplace);
              break;

            case 'm':
              var newOp = '><';
              var endDayFormatted = moment().endOf('month').format(format);
              var startDayFormatted = moment().startOf('month').format(format)
              var toReplace = 'v[spent_on][]=' + startDayFormatted + '&v[spent_on][]=' + endDayFormatted;
              queryParams = queryParams.replace('op[spent_on]=m', 'op[spent_on]=' + newOp + "&" + toReplace);
              break;

            case 'lm':
              var newOp = '><';
              var endDayFormatted = moment().subtract(1, 'months').endOf('month').format(format);
              var startDayFormatted = moment().subtract(1, 'months').startOf('month').format(format)
              var toReplace = 'v[spent_on][]=' + startDayFormatted + '&v[spent_on][]=' + endDayFormatted;
              queryParams = queryParams.replace('op[spent_on]=lm', 'op[spent_on]=' + newOp + "&" + toReplace);
              break;

            case 'y':
              var newOp = '><';
              var endDayFormatted = moment().endOf('year').format(format);
              var startDayFormatted = moment().startOf('year').format(format)
              var toReplace = 'v[spent_on][]=' + startDayFormatted + '&v[spent_on][]=' + endDayFormatted;
              queryParams = queryParams.replace('op[spent_on]=y', 'op[spent_on]=' + newOp + "&" + toReplace);
              break;
          }
          break;

        case 'user_id':
          var user_id_values = urlParams.getAll('v[user_id][]');
          for (user_id_index = 0; user_id_index < user_id_values.length; user_id_index++) {
            if (user_id_values[user_id_index] === 'me') {
              if ($('input[type=hidden][name=user_id]').length) {
                var user_id = $('input[type=hidden][name=user_id]').val();
                queryParams = queryParams.replace('v[user_id][]=me', 'v[user_id][]=' + user_id);
              }
              break;
            }
          }
          break;
      }
    }
    var href = window.location.pathname + queryParams;
    $('.add-filter').parent().append('<div class="absolute-filters"><a class="absolute-filters-link" href="'+ href +'">Make filters shareable</a></div>');
  }
  makeLinksAbsolute();

});