const buildTotalLastLevelRows = function() {
    if (!window.totalLastLevelRows) {
      let lastLevelRows = [];
      // Iterate over every last-level.
      $('.last-level').each(function() {
        // Initial row item creation.
        let row = {
          time: 0,
          row: $(this),
          parentSubtotal: null,
          topSubtotal: null,
        };

        // Build time element.
        let $tdHours = $(this).find('td.hours:last');
        row['time'] = $tdHours.find('.hours-int').html() + $tdHours.find('.hours-dec').html();

        // Build parentSubtotals.
        $previousElement = $(this);
        while ($previousElement = $previousElement.prev()) {
          if ($previousElement.hasClass('subtotal')) {
            firstSubtotalFound = true;
            row['parentSubtotal'] = $previousElement;
            if ($previousElement.prevAll('.subtotal-top').length) {
              row['topSubtotal'] = $previousElement.prevAll('.subtotal-top');
            }
            break;
          }
        }

        // Push to rows array.
        lastLevelRows.push(row);

      });
      window.totalLastLevelRows = lastLevelRows;
    }
    return window.totalLastLevelRows;
  };

  const rebuildTable = function(rows) {
    let items = restructureTable(rows);
    let $newTbody = $('<tbody></tbody>');
    flatItems(items, $newTbody);
    $newTbody.append($('tr.total'));
    $('table.list > tbody').remove();
    $('table.list').append($newTbody);
  };

  const flatItems = function(items, $tbody = null) {
    items.forEach(function(item) {
      $tbody.append(item.item);
      if (item.childrenItems) {
        flatItems(item.childrenItems, $tbody);
      }
    });
  };

  const restructureTable = function(rows) {
    let items = [];
    rows.forEach(function(row){
      let $topSubtotalFound = false;
      items.forEach(function(item) {
        if (item.item.isSameNode(row.topSubtotal[0])) {
          $topSubtotalFound = item;
          return;
        }
      });

      if (!$topSubtotalFound) {
        $topSubtotalFound = {
          item: row.topSubtotal[0],
          childrenItems: []
        };
        items.push($topSubtotalFound);
      }

      $parentSubtotal = false;
      $topSubtotalFound.childrenItems.forEach(function(item) {
        if (item.item.isSameNode(row.parentSubtotal[0])) {
          $parentSubtotal = item
          return;
        }
      });

      if (!$parentSubtotal) {
        $parentSubtotal = {
          item: row.parentSubtotal[0],
          childrenItems: []
        };
        $topSubtotalFound.childrenItems.push($parentSubtotal);
      }
      $parentSubtotal.childrenItems.push({
        item: row.row[0]
      });
    });
    return items;
  };

  const sortTableBy = function (sortType, sortDirection, sortIndex = 0) {
    if (sortType === 'total') {
      let lastLevelRows = buildTotalLastLevelRows();
      lastLevelRows = sortRows(lastLevelRows, sortDirection);
      rebuildTable(lastLevelRows);
    }
    else {
      // Skip by now.
      // @TODO: IMPLEMENT!
    }
  };

  const sortRows = function(rows, direction = 'DESC') {
    if (direction === 'ASC') {
      rows.sort(function(a, b) {
        if (parseFloat(a.time) > parseFloat(b.time)) {
          return 1;
        }
        else if (parseFloat(a.time) < parseFloat(b.time)) {
          return -1;
        }
          return 0;
        });
    }
    else {
      rows.sort(function(a, b) {
        if (parseFloat(a.time) < parseFloat(b.time)) {
          return 1;
        }
        else if (parseFloat(a.time) > parseFloat(b.time)) {
          return -1;
        }
        return 0;
      });
    }
    return rows;
  };

  $(document).ready(function() {
    $('.subtotal').each(function() {
      let $subtotal = $(this);
      $(this).children('td').each(function() {
        if ($(this).hasClass('name') && $(this).html()) {
          // This will only happen in the first iteration.
          $subtotal.addClass('subtotal-top');
        }
        return false;
      });
    });

    //$('thead .period, thead .total').each(function() {
    $('thead .total').each(function() {
      const contents = $(this).html();
      let newContent = $('<a class="sort-handler" href="#" data-sort="false" data-sort-direction="false"></a>');
      newContent.append(contents);
      $(this).html(newContent);
    });

    $('.sort-handler').click(function() {
      // Reset other sort handlers.
      $('.sort-handler').attr('data-sort', 'false');
      let currentDirection = $(this).attr('data-sort-direction');
      $('.sort-handler').attr('data-sort-direction', 'false');
      if (currentDirection === 'DESC') {
        currentDirection = 'ASC';
      }
      else {
        currentDirection = 'DESC';
      }
      // Set current sort handler.
      $(this).attr('data-sort', 'true');
      $(this).attr('data-sort-direction', currentDirection);

      const isTotal = $(this).parent().hasClass('total');

      if (isTotal) {
        sortTableBy('total', currentDirection);
      }
      else {
        // Skip by now.
        // @TODO: IMPLEMENT.
      }
    });

  });
