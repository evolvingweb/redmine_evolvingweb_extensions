$(document).ready(function() {
    setTimeout(function() {
        $('.tab-content .has-details .wiki img, .description .wiki img').each(function() {
            if ($(this)[0].naturalWidth > 500) {
                $(this).attr('width', 500);
            }
        });
    }, 500);
});