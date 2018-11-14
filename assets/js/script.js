jQuery(document).ready(function($) {
  var MAX_VOL, MIN_VOL, OVERLAY_DUR, PADDING, SCROLL_DUR, archive, archiveMedia, body, closeArchive, closeLightbox, desktopHeader, findVol, footer, hideChapterCover, lightbox, lightboxMedia, main, mobileHeader, muteVideos, onKeypress, onResize, onScroll, openArchive, openChapter, openLightbox, prepareArchive, prepareBlocks, prepareSlideshows, prevScrollTop, scrollToSection, sectionTitles, selectChapter, selectMedia, selectSection, showChapterCover, showTab, slugify, toggleArchive, toggleExpander, toggleMenu, unmuteVideos;
  body = $('body');
  main = $('main');
  sectionTitles = $('.section-titles');
  archive = $('#archive');
  archiveMedia = $('.archive-medias');
  lightbox = $('#lightbox');
  lightboxMedia = $('#lightbox-media');
  desktopHeader = $('header.desktop');
  mobileHeader = $('header.mobile');
  footer = $('footer');
  MIN_VOL = 0;
  MAX_VOL = 0.8;
  OVERLAY_DUR = 200;
  SCROLL_DUR = 500;
  PADDING = 30;
  selectChapter = function(e) {
    var chapterTitle, id, title, top, url;
    e.preventDefault();
    id = $(this).data('id');
    title = $(this).data('title');
    url = this.href;
    chapterTitle = desktopHeader.find('.chapter-title');
    history.pushState(null, null, url);
    top = main.position().top;
    $('html, body').animate({
      scrollTop: top
    }, SCROLL_DUR);
    if (main.data('id') === id) {
      return;
    }
    main.addClass('loading').data('id', id).data('url', url);
    chapterTitle.attr('href', url).find('h3').html(title);
    return openChapter(id);
  };
  openChapter = function(id) {
    main.removeClass('loaded').addClass('loading');
    return $.ajax({
      url: ajax_obj.ajaxurl,
      type: 'POST',
      dataType: 'html',
      data: {
        action: 'get_chapter',
        id: id
      },
      success: function(response) {
        main.html(response);
        main.removeClass('loading').addClass('loaded');
        return prepareBlocks();
      },
      error: function(jqXHR, textStatus, errorThrown) {
        return console.log(jqXHR, textStatus, errorThrown);
      }
    });
  };
  prepareBlocks = function() {
    var blocks;
    blocks = $('.blocks');
    sectionTitles.html('');
    blocks.find('.section-title').each(function(i, block) {
      var slug, title, titleHtml;
      title = $(block).find('.section-title-text').text();
      if (title) {
        slug = slugify(title);
        $(block).attr('id', slug);
        titleHtml = $('<h5 class="section-title"></h5>').attr('data-slug', slug).html('<a href="#' + slug + '" class="section-anchor">' + title + '</a>');
        return sectionTitles.append(titleHtml);
      }
    });
    blocks.find('.media-block').each(function(i, block) {
      var blockBody;
      if ($(block).is('.full-media-block')) {
        blockBody = $(block).find('.block-body');
        if (!blockBody.text()) {
          return blockBody.remove();
        }
      }
    });
    blocks.imagesLoaded().done(function() {
      var hash;
      if (hash = window.location.hash) {
        scrollToSection(hash, false);
      }
      $(window).on('scroll', onScroll);
      blocks.addClass('loaded');
      return onScroll();
    });
    return blocks.find('video').each(function(i, video) {
      var block;
      video.loop = true;
      video.autoplay = true;
      video.muted = true;
      block = $(video).parent();
      block.addClass('muted');
      $(video).attr('muted', 'muted');
      video.play();
      return body.one('vclick', function() {
        video.muted = false;
        $(video).attr('muted', '');
        return block.removeClass('muted');
      });
    });
  };
  prepareArchive = function() {
    archiveMedia.masonry({
      itemSelector: '.col',
      transitionDuration: 0
    });
    archiveMedia.masonry('on', 'layoutComplete', function() {
      return archiveMedia.addClass('masonry');
    });
    return archiveMedia.find('.block-media').each(function(i, block) {
      if ($(block).find('img').length) {
        return $(block).find('img')[0].onload = function() {
          if (archiveMedia.is('.masonry')) {
            return archiveMedia.masonry();
          }
        };
      } else if ($(block).find('img').length) {
        return $(block).find('video')[0].on('loadeddata', function() {
          if (archiveMedia.is('.masonry')) {
            return archiveMedia.masonry();
          }
        });
      }
    });
  };
  selectSection = function(e) {
    var hash;
    e.preventDefault();
    hash = e.target.hash;
    history.pushState(null, null, hash);
    return scrollToSection(hash, true);
  };
  scrollToSection = function(hash, animate) {
    var index, media, title, top;
    hash = decodeURIComponent(hash);
    title = $('.section-title' + hash);
    if (title.length) {
      top = title.position().top;
      if (desktopHeader.css('display') !== 'none') {
        top -= desktopHeader.innerHeight() + 1;
      }
      if (animate) {
        $('html, body').animate({
          scrollTop: top
        }, SCROLL_DUR);
      } else {
        $('html, body').scrollTop(top);
      }
    } else {
      $('html, body').scrollTop(0);
    }
    if (hash.includes('#archive')) {
      toggleArchive();
      index = parseInt(hash.split('-')[1]);
      if (!Number.isInteger(index)) {
        return;
      }
      if (media = $(archiveMedia.find('.archive-media')[index - 1])) {
        return openLightbox(media);
      }
    }
  };
  prepareSlideshows = function() {
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
  toggleArchive = function(e) {
    if (body.is('.open-archive')) {
      closeArchive();
      return e.preventDefault();
    } else {
      return openArchive();
    }
  };
  openArchive = function() {
    muteVideos();
    sectionTitles.find('.active').removeClass('active');
    return body.addClass('open-archive no-scroll');
  };
  closeArchive = function() {
    var url;
    body.removeClass('open-archive no-scroll');
    url = window.location.href.split('#')[0];
    history.pushState(null, null, url);
    return $(window).scroll();
  };
  selectMedia = function(e) {
    var media;
    media = $(this);
    return openLightbox(media);
  };
  openLightbox = function(media) {
    var bg, cloneVideo, img, src, video;
    if (!media.length || media.find('.muted').length) {
      return;
    }
    lightboxMedia = $('#lightbox-media');
    if (media.find('img').length) {
      img = media.find('img');
      src = img.attr('src');
      lightboxMedia.css({
        backgroundImage: 'url(' + src + ')'
      });
    } else if (media.find('video').length) {
      video = media.find('video')[0];
      cloneVideo = $(video).clone()[0];
      lightboxMedia.append(cloneVideo);
      cloneVideo.currentTime = video.currentTime;
      cloneVideo.volume = MAX_VOL;
      cloneVideo.muted = false;
      cloneVideo.play();
    } else if (media.css('background-image')) {
      bg = media.css('background-image');
      lightboxMedia.css({
        backgroundImage: bg
      });
    }
    body.addClass('open-lightbox no-scroll');
    return muteVideos();
  };
  closeLightbox = function(e) {
    var url;
    lightboxMedia = $('#lightbox-media');
    body.removeClass('open-lightbox no-scroll');
    if (body.hasClass('open-archive')) {
      url = window.location.href.split('#')[0];
      history.pushState(null, null, url + '#archive');
    }
    setTimeout(function() {
      return lightboxMedia.html('').attr('style', '');
    }, OVERLAY_DUR);
    return $(window).scroll();
  };
  unmuteVideos = function() {
    return $('.media-block video').each(function(i, video) {
      video.muted = false;
      return video.play();
    });
  };
  muteVideos = function() {
    return $('.media-block video').each(function(i, video) {
      return video.volume = 0;
    });
  };
  toggleMenu = function(e) {
    return body.toggleClass('open-menu no-scroll');
  };
  showChapterCover = function(e) {
    var id, media;
    id = $(this).data('id');
    media = $('.media[data-id="' + id + '"]');
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
    }, SCROLL_DUR, function() {
      if ($expandWrapper.is('.open')) {
        return $expandContent.css({
          height: 'auto'
        });
      }
    });
  };
  onResize = function(e) {
    if (footer.length) {
      $('.blocks-inner').css({
        paddingBottom: footer.innerHeight() + PADDING
      });
    }
    $('.block-media.slideshow').each(function(i, block) {
      var newHeight, ratio;
      block = $(block);
      if (ratio = block.attr('data-ratio')) {
        newHeight = block.innerWidth() * ratio;
        return block.css({
          height: newHeight + PADDING + 'px'
        });
      }
    });
    if (archiveMedia.is('.masonry')) {
      return archiveMedia.masonry();
    }
  };
  onKeypress = function(e) {
    if (e.key === 'Escape') {
      if (body.is('.open-lightbox')) {
        closeLightbox();
      }
      if (body.is('.open-archive')) {
        return closeArchive();
      }
    }
  };
  prevScrollTop = 0;
  onScroll = function(e) {
    var chapterUrl, currTitle, currTitleHtml, mainTop, scrollBottom, scrollDir, scrollTop, sectionHash, slugs, winHalf, winHeight;
    if (body.is('.page') || body.is('.archive')) {
      return;
    }
    winHeight = $(window).innerHeight();
    winHalf = winHeight / 2;
    scrollTop = $(window).scrollTop();
    scrollBottom = winHeight + scrollTop;
    scrollDir = scrollTop > prevScrollTop ? 'down' : 'up';
    mainTop = main.position().top;
    chapterUrl = main.data('url');
    if (scrollTop >= mainTop) {
      body.addClass('in-chapter');
    } else {
      body.removeClass('in-chapter');
    }
    slugs = [];
    $('.block.section-title').each(function(i, sectionTitle) {
      var sectionSlug, titleTop;
      titleTop = $(sectionTitle).offset().top - desktopHeader.innerHeight() - 1;
      if (titleTop <= scrollTop) {
        sectionSlug = $(sectionTitle).attr('id');
        return slugs.push(sectionSlug);
      }
    });
    if (currTitle = slugs[slugs.length - 1]) {
      currTitleHtml = sectionTitles.find('[data-slug="' + currTitle + '"]');
      if (!currTitleHtml.is('.active')) {
        currTitleHtml.addClass('active');
        sectionHash = currTitleHtml.find('a').attr('href');
        if (!body.is('.open-archive') && !body.is('.open-lightbox')) {
          history.pushState(null, null, chapterUrl + sectionHash);
        }
      }
    } else if (window.location.hash.length) {
      if (!body.is('.open-archive') && !body.is('.open-lightbox')) {
        history.pushState(null, null, '#');
      }
    }
    $('.section-title').not(currTitleHtml).removeClass('active');
    $('.media-block video').each(function(i, video) {
      var playPromise, videoBottom, videoBottomScroll, videoHalf, videoHeight, videoMid, videoMidScroll, videoTop, videoTopScroll, vol;
      videoHeight = $(video).innerHeight();
      videoHalf = videoHeight / 2;
      videoTop = $(video).offset().top;
      videoMid = videoHeight / 2 + videoTop;
      videoBottom = $(video).innerHeight() + videoTop;
      videoTopScroll = videoTop - scrollTop;
      videoMidScroll = scrollTop - videoMid + winHalf;
      videoBottomScroll = videoBottom - scrollTop;
      if (videoMidScroll >= 0) {
        vol = findVol(videoBottomScroll, 0, winHalf + videoHalf);
      } else {
        vol = findVol(videoTopScroll, winHeight, winHalf - videoHalf);
      }
      video.volume = vol;
      if (!video.playing) {
        playPromise = video.play();
        if (playPromise !== void 0) {
          return playPromise.then(function() {
            return $(video).attr('muted', '');
          })["catch"](function(error) {
            return console.log(error);
          });
        }
      }
    });
    return prevScrollTop = scrollTop;
  };
  findVol = function(videoPos, scrollMin, scrollMax) {
    var vol, volMax, volMin;
    volMin = MIN_VOL;
    volMax = MAX_VOL;
    vol = (videoPos - scrollMin) * (volMax - volMin) / (scrollMax - scrollMin) + volMin;
    if (vol > MAX_VOL) {
      vol = MAX_VOL;
    }
    if (vol < MIN_VOL) {
      vol = MIN_VOL;
    }
    return vol;
  };
  slugify = function(str) {
    var slug;
    slug = str.toString().toLowerCase().replace(/\s+/g, '-').replace(/\-\-+/g, '-').replace(/^-+/, '').replace(/-+$/, '');
    return slug;
  };
  body.on('vclick', '.archive-toggle', toggleArchive);
  body.on('vclick', '.menu-toggle', toggleMenu);
  body.on('mouseenter', '.chapter-square:not(.show)', showChapterCover);
  body.on('mouseleave', '.chapter-square', hideChapterCover);
  body.on('vclick', '.tabs .tab:not(.active)', showTab);
  body.on('vclick', '.expand-toggle', toggleExpander);
  body.on('vclick', '.section-anchor', selectSection);
  body.on('vclick', 'a.chapter-square', selectChapter);
  body.on('vclick', '.block-media', selectMedia);
  body.on('vclick', '.lightbox-close, #lightbox-media', closeLightbox);
  body.on('keyup', onKeypress);
  $(window).on('resize', onResize);
  $(window).on('load', function() {
    prepareBlocks();
    prepareSlideshows();
    return prepareArchive();
  });
  return onResize();
});
