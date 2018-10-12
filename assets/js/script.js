jQuery(document).ready(function($) {
  var archivalMaterials, blocks, body, clickSectionTitle, getSectionTitles, hideChapterCover, onResize, onScroll, scrollToSection, sectionTitles, setupSlideshows, showChapterCover, showTab, slugify, toggleArchival, toggleExpander, toggleMenu;
  body = $('body');
  blocks = $('.blocks');
  sectionTitles = $('.section-titles');
  archivalMaterials = $('#archival-materials');
  getSectionTitles = function() {
    return $('.section-title').each(function(i, block) {
      var slug, title, titleHtml;
      title = $(block).find('.section-title-text').text();
      if (title) {
        slug = slugify(title);
        $(block).attr('id', slug);
        titleHtml = $('<h5 class="section-title"></h5>').attr('data-title', title).html('<a href="#' + slug + '" class="section-anchor">' + title + '</a>');
        return sectionTitles.append(titleHtml);
      }
    });
  };
  clickSectionTitle = function(e) {
    e.preventDefault();
    return scrollToSection(e.target.hash);
  };
  scrollToSection = function(hash) {
    var title, top;
    if (title = $('.section-title' + hash)) {
      top = title.position().top;
      return $('html, body').animate({
        scrollTop: top
      }, 500);
    }
  };
  setupSlideshows = function() {
    return $('.block-media.slideshow').each(function(i, block) {
      var maxHeight;
      maxHeight = 0;
      block = $(block);
      block.imagesLoaded().progress(function(inst, image) {
        var img, media;
        img = image.img;
        media = $(img).parent();
        if (img.naturalHeight > maxHeight) {
          maxHeight = img.naturalHeight;
          block.find('.static').removeClass('static');
          block.attr('data-ratio', img.naturalHeight / img.naturalWidth);
          return media.addClass('static');
        }
      }).done(function(inst) {
        return $(window).resize();
      });
      return setInterval(function() {
        var activeMedia, nextMedia;
        activeMedia = block.find('.active');
        if (activeMedia.length) {
          nextMedia = block.find('.active').next('.media');
        }
        if (!nextMedia || !nextMedia.length) {
          nextMedia = block.find('.media').first();
        }
        block.find('.active').removeClass('active');
        return nextMedia.addClass('active');
      }, 5000);
    });
  };
  onResize = function(e) {
    $('.objects').masonry();
    return $('.block-media.slideshow').each(function(i, block) {
      var newHeight, ratio;
      block = $(block);
      if (ratio = block.attr('data-ratio')) {
        newHeight = block.innerWidth() * ratio;
        return block.css({
          height: newHeight + 30 + 'px'
        });
      }
    });
  };
  toggleArchival = function(e) {
    return body.toggleClass('open-archive');
  };
  toggleMenu = function(e) {
    return body.toggleClass('open-menu');
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
  slugify = function(str) {
    return str.toString().toLowerCase().replace(/\s+/g, '-').replace(/[^\w\-]+/g, '').replace(/\-\-+/g, '-').replace(/^-+/, '').replace(/-+$/, '');
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
  $('body').on('click', '.archival-toggle', toggleArchival);
  $('body').on('click', '.menu-toggle', toggleMenu);
  $('body').on('mouseenter', '.chapter-square:not(.show)', showChapterCover);
  $('body').on('mouseleave', '.chapter-square', hideChapterCover);
  $('body').on('click', '.tabs .tab:not(.active)', showTab);
  $('body').on('click', '.expand-toggle', toggleExpander);
  $('body').on('click', '.section-anchor', clickSectionTitle);
  $(window).on('scroll', onScroll);
  $(window).on('resize', onResize);
  getSectionTitles();
  return setupSlideshows();
});
