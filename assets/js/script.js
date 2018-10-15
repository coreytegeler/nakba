jQuery(document).ready(function($) {
  var archivalMaterials, blocks, body, desktopHeader, getSectionTitles, hideChapterCover, main, mobileHeader, onResize, onScroll, scrollToSection, sectionTitles, selectChapter, selectSection, setupSlideshows, showChapterCover, showTab, slugify, toggleArchival, toggleExpander, toggleMenu;
  body = $('body');
  main = $('main');
  blocks = $('.blocks');
  sectionTitles = $('.section-titles');
  archivalMaterials = $('#archival-materials');
  desktopHeader = $('header.desktop');
  mobileHeader = $('header.mobile');
  selectChapter = function(e) {
    var href, id, title, top;
    e.preventDefault();
    id = $(this).data('id');
    title = $(this).data('title');
    href = this.href;
    history.pushState(null, null, href);
    top = main.position().top;
    $('html, body').animate({
      scrollTop: top
    }, 500);
    if (main.data('id') === id) {
      return;
    }
    main.addClass('loading').data('id', id);
    desktopHeader.find('.chapter-title h3').html(title);
    return $.ajax({
      url: ajax_obj.ajaxurl,
      type: 'POST',
      dataType: 'html',
      data: {
        action: 'get_chapter',
        id: id
      },
      success: function(response) {
        main.append(response);
        main.removeClass('loading').addClass('loaded');
        return getSectionTitles();
      },
      error: function(jqXHR, textStatus, errorThrown) {
        return console.log(jqXHR, textStatus, errorThrown);
      }
    });
  };
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
  selectSection = function(e) {
    var hash;
    e.preventDefault();
    hash = e.target.hash;
    history.pushState(null, null, hash);
    return scrollToSection(hash);
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
    var url;
    body.toggleClass('open-archive');
    if (!body.is('.open-archive')) {
      e.preventDefault();
      url = window.location.href.split('#')[0];
      return history.pushState(null, null, url);
    }
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
    var currTitle, currTitleHtml, mainTop, scrollBottom, scrollTop, titles, url;
    scrollTop = $(this).scrollTop();
    scrollBottom = $(window).innerHeight() + scrollTop;
    mainTop = main.position().top;
    if (scrollTop >= mainTop) {
      body.addClass('in-chapter');
    } else {
      body.removeClass('in-chapter');
    }
    titles = [];
    $('.block.section-title').each(function(i, sectionTitle) {
      var sectionTitleText, titleTop;
      titleTop = $(sectionTitle).offset().top;
      if (titleTop <= scrollTop) {
        sectionTitleText = $(sectionTitle).find('.section-title-text').text();
        return titles.push(sectionTitleText);
      }
    });
    if (currTitle = titles[titles.length - 1]) {
      currTitleHtml = sectionTitles.find('[data-title="' + currTitle + '"]');
      if (!currTitleHtml.is('.active')) {
        currTitleHtml.addClass('active');
        url = currTitleHtml.find('a')[0].href;
        history.pushState(null, null, url);
      }
    } else if (window.location.hash.length) {
      history.pushState(null, null, '#');
    }
    $('.section-title').not(currTitleHtml).removeClass('active');
    return $('.media-block video').each(function(i, video) {
      var videoBottom, videoTop;
      videoTop = $(video).offset().top;
      videoBottom = $(video).innerHeight() + videoTop;
      if (videoTop <= scrollBottom && videoBottom >= scrollTop && video.paused) {
        video.play();
        if (!$(video).attr('loop')) {
          $(video).attr('loop', 'loop');
        }
        return video.animate({
          volume: 1
        }, 1000);
      } else if (videoTop >= scrollBottom || videoBottom <= scrollTop && !video.paused) {
        video.animate({
          volume: 0
        }, 1000);
        return setTimeout(function() {
          return video.pause();
        }, 1000);
      }
    });
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
  $('body').on('click', '.section-anchor', selectSection);
  $('body').on('click', '.chapter-square', selectChapter);
  $(window).on('scroll', onScroll);
  $(window).on('resize', onResize);
  getSectionTitles();
  return setupSlideshows();
});
