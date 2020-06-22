$(document).ready(function() {
    setTimeout(function() {
        $('.tab-content .has-details .wiki img, .description .wiki img').each(function() {
            if ($(this)[0].naturalWidth > 500) {
                $(this).attr('width', 500);
                const regex = /^\/attachments\/download\/(\d+)\//;
                var matches;
                var href;
                if ((matches = regex.exec($(this).attr('src'))) !== null) {
                    if (matches[1]) {
                        href = '/attachments/' + matches[1];
                    }
                }
                if (href) {
                    $(this).wrap('<a href="' + href + '"></a>');
                }
            }
        });
    }, 500);
});