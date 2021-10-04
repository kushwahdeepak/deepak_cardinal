$(document).on('load', function() {
    if ($(".single-job_post-card").length) {
        // set a solid background color style
        if (mode == 1) {
            $(".single-job_post-card").each(function() {
                $(this).addClass("solid-color-mode");
                $(this).css('background-color', randomColor());
            });
        }
        // set a border color style
        else {
            $(".single-job_post-card").each(function() {
                $(this).addClass("border-color-mode");
                $(this).css('border', '5px solid ' + randomColor());
            });
        }
    }


    $('#feed').on( 'mouseenter', '.single-job_post-list', function() {
        $(this).css('border-color', randomColor());
    });

    $('#feed').on( 'mouseleave', '.single-job_post-list', function() {
        $(this).css('border-color', 'rgba(0, 0 , 0, 0.05)');
    });

    var colorSet = randomColorSet();
    var mode = Math.floor(Math.random() * 2);

    // Randomly returns a color scheme
    function randomColorSet() {
      var colorSet1 = ['#45CCFF', '#49E83E', '#FFD432', '#E84B30', '#B243FF'];
      var colorSet2 = ['#FF6138', '#FFFF9D', '#BEEB9F', '#79BD8F', '#79BD8F'];
      var colorSet3 = ['#FCFFF5', '#D1DBBD', '#91AA9D', '#3E606F', '#193441'];
      var colorSet4 = ['#004358', '#1F8A70', '#BEDB39', '#FFE11A', '#FD7400'];
      var colorSet5 = ['#105B63', '#FFFAD5', '#FFD34E', '#DB9E36', '#BD4932'];
      var colorSet6 = ['#04BFBF', '#CAFCD8', '#F7E967', '#A9CF54', '#588F27'];
      var colorSet7 = ['#405952', '#9C9B7A', '#FFD393', '#FF974F', '#F54F29'];
      var randomSet = [colorSet1, colorSet2, colorSet3, colorSet4, colorSet5, colorSet6, colorSet7];
      return randomSet[Math.floor(Math.random() * randomSet.length )];
    }
    // Randomly returns a color from an array of colors
    function randomColor() {
      var color = colorSet[Math.floor(Math.random() * colorSet.length)];
      return color;
    }
    // when a post is clicked, show its full content in a modal window
    $("body").on( "click", ".single-job_post-card, .single-job_post-list", function() {
      var posted_by = $(this).find('.job_job_post-content .posted-by').html();
      var post_heading = $(this).find('.job_job_post-content h3').html();
      var post_content = $(this).find('.job_job_post-content p').html();
      var interested = $(this).find('.job_job_post-content .interested').attr('href');
      $('.modal-header .posted-by').text(posted_by);
      $('.loaded-data h3').text(post_heading);
      $('.loaded-data p').text(post_content);
      $('.loaded-data .interested a').attr('href', interested);
      $('.myModal').modal('show');
    });
});
