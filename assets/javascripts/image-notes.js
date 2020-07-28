$(document).ready(function() {
    function processImage($element) {
        if ($element[0].naturalWidth > 500) {
            $element.attr('width', 500);
            const regex = /^\/attachments\/download\/(\d+)\//;
            var matches;
            var href;
            if ((matches = regex.exec($element.attr('src'))) !== null) {
                if (matches[1]) {
                    href = '/attachments/' + matches[1];
                }
            }
            if (href) {
                $element.wrap('<a href="' + href + '"></a>');
            }
        }
    }
    setTimeout(function() {
        $('.tab-content .has-details .wiki img, .description .wiki img').each(function() {
            processImage($(this));
        });
    }, 500);
    $('.jstTabs > ul > li:nth-of-type(2)').click(function() {
        setTimeout(function() {
            $('.wiki-preview img').each(function() {
                processImage($(this));
            })
        }, 500);
    });
});
