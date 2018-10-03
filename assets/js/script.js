jQuery(document).ready(function($) {
  var archivalMaterials, blocks, body, getSectionTitles, hideChapterCover, onScroll, sectionTitles, showChapterCover, showTab, toggleArchival, toggleExpander;
  body = $('body');
  blocks = $('.blocks');
  sectionTitles = $('.section-titles');
  archivalMaterials = $('#archival-materials');
  getSectionTitles = function() {
    return $('.section-title').each(function(i, block) {
      var title, titleHtml;
      title = $(block).find('.section-title-text').text();
      if (title) {
        titleHtml = $('<h3 class="section-title"></h3>').html(title).attr('data-title', title);
        return sectionTitles.append(titleHtml);
      }
    });
  };
  toggleArchival = function(e) {
    body.toggleClass('open-archive');
    if (archivalMaterials.is('.open-archive')) {
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
  showTab = function(e) {
    var $content, id;
    id = $(this).data('id');
    $content = $('.tab-content[data-id="' + id + '"]');
    $('.tab, .tab-content').removeClass('active');
    $(this).addClass('active');
    return $content.addClass('active');
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
  onScroll = function(e) {
    var currTitle, currTitleHtml, scrollTop, titles;
    scrollTop = $(this).scrollTop();
    titles = [];
    $('.section-title').each(function(i, sectionTitle) {
      var sectionTitleText;
      if (scrollTop >= $(sectionTitle).offset().top) {
        sectionTitleText = $(sectionTitle).find('.section-title-text').text();
        return titles.push(sectionTitleText);
      }
    });
    currTitle = titles[titles.length - 1];
    currTitleHtml = sectionTitles.find('[data-title="' + currTitle + '"]');
    $('.section-title').not(currTitleHtml).removeClass('active');
    return currTitleHtml.addClass('active');
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
  $('body').on('click', '.tabs .tab:not(.active)', showTab);
  $('body').on('click', '.expand-toggle', toggleExpander);
  $(window).on('scroll', onScroll);
  return getSectionTitles();
});
