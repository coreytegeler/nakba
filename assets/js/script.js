jQuery(document).ready(function($) {
  var archivalMaterials, blockTitles, blocks, body, getBlockTitles, hideChapterCover, showChapterCover, toggleArchival, toggleExpander;
  body = $('body');
  blocks = $('.blocks');
  blockTitles = $('.block-titles');
  archivalMaterials = $('#archival-materials');
  getBlockTitles = function() {
    return blocks.children().each(function(i, block) {
      var title;
      title = $(block).find('.block-title').text();
      if (title) {
        return blockTitles.append('<h3 class="block-title">' + title + '</h3>');
      }
    });
  };
  toggleArchival = function(e) {
    archivalMaterials.toggleClass('open');
    if (archivalMaterials.is('.open')) {
      return body.addClass('no-scroll');
    } else {
      return body.removeClass('no-scroll');
    }
  };
  showChapterCover = function(e) {
    var media, slug;
    slug = $(this).data('slug');
    media = $('.media[data-slug="' + slug + '"]');
    if (media.length) {
      $('.media').removeClass('show');
      return media.addClass('show');
    }
  };
  hideChapterCover = function(e) {
    return $('.media').removeClass('show');
  };
  toggleExpander = function(e) {
    var $expandContent, $expandWrapper, $inner, innerHeight;
    $expandWrapper = $(this).parents('.expand-wrapper');
    $expandContent = $expandWrapper.find('.expand-content');
    $expandWrapper.toggleClass('open');
    if ($expandWrapper.is('.open')) {
      $inner = $expandWrapper.find('.expand-inner');
      innerHeight = $inner.innerHeight();
    } else {
      innerHeight = 0;
    }
    return $expandContent.animate({
      height: innerHeight
    }, 500, function() {
      if ($expandWrapper.is('.open')) {
        return $expandContent.css({
          height: 'auto'
        });
      }
    });
  };
  $('.objects').masonry({
    itemSelector: '.object',
    columnWidth: '.col',
    transitionDuration: 0
  });
  $('.objects img').each(function(i, img) {
    return img.onload = function() {
      return $('.objects').masonry();
    };
  });
  $('.objects video').each(function(i, video) {
    return $(video).on('loadeddata', function() {
      return $('.objects').masonry();
    });
  });
  $(window).on('resize', function() {
    return $('.objects').masonry();
  });
  $('body').on('click', '.archival-toggle', toggleArchival);
  $('body').on('mouseenter', '.chapter-square:not(.show)', showChapterCover);
  $('body').on('mouseleave', '.chapter-square', hideChapterCover);
  $('body').on('click', '.expand-toggle', toggleExpander);
  return getBlockTitles();
});
